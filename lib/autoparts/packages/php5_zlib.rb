require 'autoparts/packages/php5_ext'

module Autoparts
  module Packages
    class Php5Zlib < Package
      include Php5Ext

      name 'php5-zlib'
      description 'zlib module for php5'
      depends_on 'php5'
      category Category::WEB_DEVELOPMENT

      def php_extension_name
        'zlib'
      end
    end
  end
end