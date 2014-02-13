require File.join(File.dirname(__FILE__), 'php5ext')

module Autoparts
  module Packages
    class Php5ExtIntl < Php5Ext
      name 'php5-intl'
      description 'Intl module for php5'
      depends_on 'php5'

      def php_extension_name
        'intl'
      end

    end
  end
end