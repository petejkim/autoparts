require 'autoparts/packages/php5_ext'

module Autoparts
  module Packages
    class Php5Ssh2 < Package
      include Php5Ext

      name 'php5-ssh2'
      version '0.12'
      description 'SSH2 module for php5'
      source_url 'http://pecl.php.net/get/ssh2-0.12.tgz'
      source_sha1 'b86a25bdd3f3558bbcaaa6d876309fbbb5ae134d'
      source_filetype 'tgz'
      category Category::WEB_DEVELOPMENT

      depends_on 'php5'

      def php_extension_name
        "ssh2"
      end

      def php_extension_dir
        "ssh2-0.12"
      end

    end
  end
end
