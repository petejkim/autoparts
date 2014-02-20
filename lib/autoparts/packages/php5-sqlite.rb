require File.join(File.dirname(__FILE__), 'php5ext')

module Autoparts
  module Packages
    class Php5ExtSqlite < Php5Ext
      name 'php5-sqlite'
      description 'Sqlite3 module for php5'

      depends_on 'php5'

      def php_extension_name
        "sqlite3"
      end

      def compile
        Dir.chdir(php_extension_dir) do
          execute 'mv', 'config0.m4', 'config.m4'
        end
        super
      end

    end
  end
end
