require 'autoparts/packages/php5_ext'

module Autoparts
  module Packages
    class Php5PdoSqlite < Package
      include Php5Ext

      name 'php5-pdo-sqlite'
      description 'PDO SQLite module for php5'
      category Category::WEB_DEVELOPMENT

      depends_on 'php5'
      depends_on 'sqlite3'

      def php_extension_name
        'pdo_sqlite'
      end

      def php_compile_args
        [
          "--with-pdo-sqlite=#{get_dependency("sqlite3").prefix_path}",
        ]
      end
    end
  end
end