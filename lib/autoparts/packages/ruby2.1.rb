# Copyright (c) 2013-2014 Irrational Industries Inc. d.b.a. Nitrous.IO
# This software is licensed under the [BSD 2-Clause license](https://raw.github.com/nitrous-io/autoparts/master/LICENSE).

module Autoparts
  module Packages
    class Ruby21 < Package
      name 'ruby2.1'
      version '2.1.1'
      description 'Ruby 2.1.1: A dynamic programming language with a focus on simplicity and productivity.'
      source_url 'http://cache.ruby-lang.org/pub/ruby/2.1/ruby-2.1.1.tar.gz'
      source_sha1 '27cbc8ae98863b4607ede8085beca2a20f4c03fd'
      source_filetype 'tar.gz'

      depends_on 'chruby'

      def compile
        Dir.chdir(ruby_version) do
          args = [
            "--prefix=#{prefix_path}"
          ]
          execute "./configure", *args
        end
      end

      def install
        Dir.chdir(ruby_version) do
          execute "make install"
        end
      end

      def post_install
        execute "ln", "-sf", prefix_path, chruby_path
      end

      def post_uninstall
        FileUtils.rm_rf chruby_path
      end

      def chruby_path
        get_dependency("chruby").rubies_dir + ruby_version
      end

      def ruby_version
        "ruby-#{version}"
      end

      def tips
        <<-EOF.unindent
        You can switch ruby versions with chruby
        First, reload chruby definitions
          $ eval "$(parts init -)"
        Then, new ruby version should appear in chruby list
          $ chruby
        And you can switch to the new version
          $ chruby new_ruby_version
        More information about chruby here https://github.com/postmodern/chruby
        EOF
      end
    end
  end
end
