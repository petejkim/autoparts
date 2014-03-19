require 'autoparts/packages/php5_ext'

module Autoparts
  module Packages
    class Php5Bz2 < Package
      include Php5Ext

      name 'php5-bz2'
      description 'BZ2 module for php5'
      category Category::WEB_DEVELOPMENT

      depends_on 'php5'

      def php_extension_name
        'bz2'
      end

    end
  end
end