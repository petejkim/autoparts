require File.join(File.dirname(__FILE__), 'php5_ext')

module Autoparts
  module Packages
    class Php5Exif < Php5Ext
      name 'php5-exif'
      description 'Exif module for php5'
      category Category::WEB_DEVELOPMENT

      depends_on 'php5'

      def php_extension_name
        "exif"
      end
    end
  end
end
