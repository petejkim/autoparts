require File.join(File.dirname(__FILE__), 'php5ext')

module Autoparts
  module Packages
    class Php5ExtFtp < Php5Ext
      name 'php5-ftp'
      description 'ftp module for php5'
      depends_on 'php5'

      def php_extension_name
        'ftp'
      end
    end
  end
end