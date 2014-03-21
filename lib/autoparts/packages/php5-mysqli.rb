require 'autoparts/packages/php5_ext'

module Autoparts
  module Packages
    class Php5Mysqli < Package
      include Php5Ext

      name 'php5-mysqli'
      description 'MySQLi module for php5'
      category Category::WEB_DEVELOPMENT

      depends_on 'php5'

      def php_extension_name
        'mysqli'
      end

    end
  end
end