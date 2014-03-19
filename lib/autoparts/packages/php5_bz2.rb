require File.join(File.dirname(__FILE__), 'php5_ext')

module Autoparts
  module Packages
    class Php5Bz2 < Php5Ext
      name 'php5-bz2'
      description 'BZ2 module for php5'
      depends_on 'php5'
      category Category::WEB_DEVELOPMENT

      def php_extension_name
        'bz2'
      end

    end
  end
end