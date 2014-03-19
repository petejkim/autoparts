require 'autoparts/packages/php5_ext'

module Autoparts
  module Packages
    class Php5Iconv < Package
      include Php5Ext

      name 'php5-iconv'
      description 'Iconv module for php5'
      category Category::WEB_DEVELOPMENT

      depends_on 'php5'

      def php_extension_name
        'iconv'
      end

    end
  end
end