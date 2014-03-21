require 'autoparts/packages/php5_ext'

#freetds library required, will research on a user request
=begin
module Autoparts
  module Packages
    class Php5PdoDblib < Package
      include Php5Ext

      name 'php5-pdo-dblib'
      description 'PDO DBLib module for php5'
      category Category::WEB_DEVELOPMENT

      depends_on 'php5'

      def php_extension_name
        'pdo_dblib'
      end

    end
  end
end
=end