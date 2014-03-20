require 'autoparts/packages/php5_ext'

module Autoparts
  module Packages
    class Php5zip < Package
      include Php5Ext

      name 'php5-zip'
      description 'zip module for php5'
      depends_on 'php5'
      category Category::WEB_DEVELOPMENT

      def php_extension_name
        'zip'
      end
    end
  end
end