module Autoparts
  module Packages
    class PhpUnit < Package
      name 'phpunit'
      version '3.7.32'
      description 'PHPUnit is a programmer-oriented testing framework for PHP.'
      source_url 'https://phar.phpunit.de/phpunit.phar'
      source_sha1 'cf74cb5abe92190c6e9aa472124e28ae5d5e49ca'
      source_filetype 'php'

      depends_on 'php5'

      def install
        bin_path.mkpath
        execute 'mv', archive_filename, phpinut_executable_path
        execute 'chmod', '0755', phpinut_executable_path
      end

      def phpinut_executable_path
        bin_path + 'phpunit'
      end

      def tips
        <<-EOS.unindent
          To check version of phpunit:
            $ phpunit --version
        EOS
      end
    end
  end
end
