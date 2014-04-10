module Autoparts
  module Packages
    class PhpUnit < Package
      name 'phpunit'
      version '4.0.14'
      description 'PHPUnit: A programmer-oriented unit testing framework for PHP'
      source_url 'https://phar.phpunit.de/phpunit-4.0.14.phar'
      source_sha1 '756c8ffd612a242ef1adb88a1d456de8f220ccd4'
      source_filetype 'php'
      category Category::DEVELOPMENT_TOOLS

      depends_on 'php5'

      def install
        bin_path.mkpath
        execute 'mv', archive_filename, phpunit_executable_path
        execute 'chmod', '0755', phpunit_executable_path
      end

      def phpunit_executable_path
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