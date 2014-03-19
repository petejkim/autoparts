require 'autoparts/packages/php5_ext'

module Autoparts
  module Packages
    class Php5PdoMysql < Package
      include Php5Ext

      name 'php5-pdo-mysql'
      description 'PDO MySql module for php5'
      category Category::WEB_DEVELOPMENT

      depends_on 'php5'
      depends_on 'mysql'

      def php_extension_name
        'pdo_mysql'
      end
      def php_compile_args
        [
          "--with-pdo-mysql=#{get_dependency("mysql").prefix_path}",
        ]
      end
    end
  end
end