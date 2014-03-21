require 'autoparts/packages/php5_ext'

module Autoparts
  module Packages
    class Php5Soap < Package
      include Php5Ext

      name 'php5-soap'
      description 'soap module for php5'
      category Category::WEB_DEVELOPMENT

      depends_on 'php5'

      def php_extension_name
        'soap'
      end
    end
  end
end