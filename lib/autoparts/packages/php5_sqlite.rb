require 'autoparts/packages/php5_ext'

module Autoparts
  module Packages
    class Php5Sqlite < Package
      include Php5Ext

      name 'php5-sqlite'
      description 'SQLite3 module for php5'
      category Category::WEB_DEVELOPMENT

      depends_on 'php5'

      def php_extension_name
        'sqlite3'
      end

    end
  end
end