require 'autoparts/packages/php5_ext'

module Autoparts
  module Packages
    class Php5Pgsql < Package
      include Php5Ext

      name 'php5-pgsql'
      description 'PostgreSQL module for php5'
      category Category::WEB_DEVELOPMENT

      depends_on 'php5'

      def php_extension_name
        'pgsql'
      end
    end
  end
end