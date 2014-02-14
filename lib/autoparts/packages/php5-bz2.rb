require File.join(File.dirname(__FILE__), 'php5ext')

module Autoparts
  module Packages
    class Php5Extbz2 < Php5Ext
      name 'php5-bz2'
      description 'BZ2 module for php5'
      depends_on 'php5'

      def php_extension_name
        'bz2'
      end

    end
  end
end