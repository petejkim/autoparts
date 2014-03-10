require 'autoparts/packages/php5_ext'

module Autoparts
  module Packages
    class Php5Intl < Php5Ext
      name 'php5-intl'
      description 'Intl module for php5'
      depends_on 'php5'

      def php_extension_name
        'intl'
      end

    end
  end
end