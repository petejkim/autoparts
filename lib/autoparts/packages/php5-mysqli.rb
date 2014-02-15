require File.join(File.dirname(__FILE__), 'php5ext')

module Autoparts
  module Packages
    class Php5ExtMysqli < Php5Ext
      name 'php5-mysqli'
      description 'mysqli module for php5'
      depends_on 'php5'

      def php_extension_name
        'mysqli'
      end
    end
  end
end