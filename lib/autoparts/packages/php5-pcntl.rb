require File.join(File.dirname(__FILE__), 'php5ext')

module Autoparts
  module Packages
    class Php5ExtPcntl < Php5Ext
      name 'php5-pcntl'
      description 'Process Control support module for php5'
      depends_on 'php5'

      def php_extension_name
        'pcntl'
      end
    end
  end
end