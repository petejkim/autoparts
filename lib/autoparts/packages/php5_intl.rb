require 'autoparts/packages/php5_ext'

module Autoparts
  module Packages
    class Php5Intl < Package
      include Php5Ext

      name 'php5-intl'
      description 'Intl module for php5'
      category Category::WEB_DEVELOPMENT

      depends_on 'php5'

      def php_extension_name
        'intl'
      end

    end
  end
end