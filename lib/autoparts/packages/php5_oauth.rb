require 'autoparts/packages/php5_ext'

module Autoparts
  module Packages
    class Php5Oauth < Package
      include Php5Ext

      name 'php5-oauth'
      version '1.2.3'
      description 'OAuth module for php5'
      source_url 'http://pecl.php.net/get/oauth-1.2.3.tgz'
      source_sha1 'e2a42961c8134746fc0cd8ef9bd433f760b94975'
      source_filetype 'tgz'
      category Category::WEB_DEVELOPMENT

      depends_on 'php5'

      def php_extension_name
        "oauth"
      end

      def php_extension_dir
        "oauth-1.2.3"
      end

    end
  end
end
