# Copyright (c) 2013-2014 Irrational Industries Inc. d.b.a. Nitrous.IO
# This software is licensed under the [BSD 2-Clause license](https://raw.github.com/nitrous-io/autoparts/master/LICENSE).

module Autoparts
  module Packages
    class Ruby21 < Package
      name 'ruby2.2'
      version '2.2.0'
      description 'Ruby 2.2.0: A dynamic programming language with a focus on simplicity and productivity.'
      source_url 'http://cache.ruby-lang.org/pub/ruby/2.2/ruby-2.2.0.tar.gz'
      source_sha1 '680302104b24f850fddfe93ee37396de01765b37'
      source_filetype 'tar.gz'

      category Category::PROGRAMMING_LANGUAGES

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
        File.open(Pathname.new(Dir.home) + '.ruby-version', 'w') do |f|
          f.write "ruby-#{version}"
        end
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
          Please restart your shell session to use the newly installed version of Ruby.

          * You can install Bundler by running `gem install bundler`.
          * You can switch between installed Ruby versions using `chruby`.
          * You can set default Ruby version by editing ~/.ruby-version file.

          Read more about chruby at: https://github.com/postmodern/chruby
        EOF
      end
    end
  end
end
