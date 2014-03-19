require 'autoparts/packages/php5_ext'

module Autoparts
  module Packages
    class Php5Mysql < Package
      include Php5Ext

      name 'php5-mysql'
      description 'MySQL module for php5'
      category Category::WEB_DEVELOPMENT

      depends_on 'php5'

      def php_extension_name
        'mysql'
      end

    end
  end
end