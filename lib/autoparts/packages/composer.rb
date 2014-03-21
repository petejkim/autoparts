module Autoparts
  module Packages
    class Composer < Package
      name 'composer'
      version '1.0.0-alpha8'
      description 'Composer: PHP5 Dependency management'
      source_url 'https://getcomposer.org/composer.phar'
      source_sha1 '22f3bd3e852f8793376417018ceaba81079a3c26'
      source_filetype 'php'

      depends_on 'php5'

      def install
        bin_path.mkpath
        execute 'mv', archive_filename, composer_executable_path
        execute 'chmod', '0755', composer_executable_path
      end

      def env_file
        Path.env + name
      end

      def composer_executable_path
        bin_path + 'composer'
      end

      def composer_env
        'PATH="$HOME/.composer/vendor/bin:$PATH"'
      end

      def post_install
        File.write(env_file, composer_env)
      end

      def post_uninstall
        env_file.unlink if env_file.exist?
      end

      def tips

        <<-EOS.unindent
          To check version of composer:
            $ composer --version
        EOS
      end
    end
  end
end
