require File.join(File.dirname(__FILE__), 'php5_ext')

module Autoparts
  module Packages
    class Php5Pcntl < Php5Ext
      name 'php5-pcntl'
      description 'Process Control support module for php5'
      category Category::WEB_DEVELOPMENT

      depends_on 'php5'

      def php_extension_name
        'pcntl'
      end
    end
  end
end