# Copyright (c) 2013-2014 Irrational Industries Inc. d.b.a. Nitrous.IO
# This software is licensed under the [BSD 2-Clause license](https://raw.github.com/nitrous-io/autoparts/master/LICENSE).

module Autoparts
  module Packages
    class RubyInstall < Package
      name 'ruby_install'
      version '0.4.1'
      description 'Ruby Install: Installs Ruby, JRuby, Rubinius, MagLev or MRuby'
      source_url 'https://github.com/postmodern/ruby-install/archive/v0.4.1.tar.gz'
      source_sha1 '8a62fa5e551101d433cf25bd67c06d47d00c3ab8'
      source_filetype 'tar.gz'

      depends_on "chruby"

      def install
        Dir.chdir('ruby-install-0.4.1') do
          execute "make", "install", "PREFIX=#{prefix_path}"
        end
      end

      # setup the directories to store rubies. The actual space for src will
      # only matter when user manually compile it and not using the precompiled
      # binaries
      def post_install
        execute 'mkdir', '-p', Path.share + "ruby"
        rubies_dir
        rubies_src_dir
      end

      def post_symlink
        FileUtils.rm_rf ruby_install_link
        File.open(ruby_install_link, "w") { |f| f.write ruby_install_binstub }
        execute 'chmod', '+x', ruby_install_link
      end

      def post_uninstall
        FileUtils.rm_rf ruby_install_link
      end

      def ruby_install_link
        Path.bin + "ruby-install"
      end

      def rubies_dir
        get_dependency("chruby").rubies_dir
      end

      def rubies_src_dir
        path = Path.share + "ruby" + "src"
        path.mkpath unless path.exist?
        path
      end

      # to have sensible options with autoparts
      def ruby_install_binstub
        <<-EOF.unindent
        #!/bin/bash
        # to have sensible default options with autoparts
        #{bin_path}/ruby-install --no-install-deps --no-reinstall --src-dir #{rubies_src_dir} --rubies-dir #{rubies_dir} $@

        cat << "DOC"
        If you have just installed a new ruby, you can activate it using chruby.
        First, reload chruby definitions
          $ eval "$(parts init -)"
        Then, new ruby version should appear in chruby list
          $ chruby
        And you can switch to the new version
          $ chruby new_ruby_version
        More information about chruby here https://github.com/postmodern/chruby
        DOC
        EOF
      end
    end
  end
end
