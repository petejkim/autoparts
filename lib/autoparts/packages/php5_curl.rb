require 'autoparts/packages/php5_ext'

module Autoparts
  module Packages
    class Php5Curl < Package
      include Php5Ext

      name 'php5-curl'
      description 'curl module for php5'
      category Category::WEB_DEVELOPMENT

      depends_on 'php5'

      def php_extension_name
        'curl'
      end
    end
  end
end