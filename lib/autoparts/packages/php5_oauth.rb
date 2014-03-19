require 'autoparts/packages/php5_ext'

module Autoparts
  module Packages
    class Php5Oauth < Php5Ext
      name 'php5-oauth'
      category Category::WEB_DEVELOPMENT

      def version
        '1.2.3'
      end

      description 'OAuth module for php5'

      def source_url
        'http://pecl.php.net/get/oauth-1.2.3.tgz'
      end

      def source_sha1
        'e2a42961c8134746fc0cd8ef9bd433f760b94975'
      end

      def source_filetype
        'tgz'
      end

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
