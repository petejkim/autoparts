# Copyright (c) 2013-2014 Irrational Industries Inc. d.b.a. Nitrous.IO
# This software is licensed under the [BSD 2-Clause license](https://raw.github.com/nitrous-io/autoparts/master/LICENSE).

module Autoparts
  module Packages
    class Composer < Package
      name 'composer'
      version '1.0.0-alpha9'
      description 'Composer: PHP5 Dependency management'
      category Category::DEVELOPMENT_TOOLS

      source_url 'http://getcomposer.org/download/1.0.0-alpha9/composer.phar'
      source_sha1 '10fcb5a5694afa539df0237090db19e73bd35ed0'
      source_filetype 'php'

      depends_on 'php5'

      def install
        bin_path.mkpath
        execute 'mv', archive_filename, composer_executable_path
        execute 'chmod', '0755', composer_executable_path
      end

      def composer_executable_path
        bin_path + 'composer'
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
