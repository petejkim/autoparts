require 'autoparts/packages/php5_ext'

module Autoparts
  module Packages
    class Php5PdoPgsql < Package
      include Php5Ext

      name 'php5-pdo-pgsql'
      description 'PDO PostgreSQL module for php5'
      category Category::WEB_DEVELOPMENT

      depends_on 'php5'
      depends_on 'postgresql'

      def php_extension_name
        'pdo_pgsql'
      end
      def php_compile_args
        [
          "--with-pdo-pgsql=#{get_dependency("postgresql").prefix_path}",
        ]
      end
    end
  end
end