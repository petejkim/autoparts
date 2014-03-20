require 'autoparts/packages/php5_ext'

module Autoparts
  module Packages
    class Php5Ftp < Package
      include Php5Ext

      name 'php5-ftp'
      description 'ftp module for php5'
      depends_on 'php5'
      category Category::WEB_DEVELOPMENT

      def php_extension_name
        'ftp'
      end
    end
  end
end