=begin Compile problems
require 'autoparts/packages/php5_ext'

module Autoparts
  module Packages
    class Php5Mysql < Package
      include Php5Ext

      name 'php5-mysql'
      description 'MySQL module for php5'
      category Category::WEB_DEVELOPMENT

      depends_on 'php5'

      def php_extension_name
        'mysqlnd'
      end

      def php_compile_args
        [
          "--with-mcrypt=#{get_dependency("libmcrypt").prefix_path}",
          # path
          "--prefix=#{prefix_path}",
          "--bindir=#{bin_path}",
          "--sbindir=#{bin_path}",
          "--sysconfdir=#{Path.etc + name}",
          "--libdir=#{lib_path}",
          "--includedir=#{include_path}",
          "--datarootdir=#{share_path}/#{name}",
          "--datadir=#{share_path}/#{name}",
          "--with-mysql-sock=/tmp/mysql.sock",
          "--mandir=#{man_path}",
          "--docdir=#{doc_path}",
          # features
          "--enable-opcache",
          "--enable-pdo",
          "--with-openssl",
          "--with-readline",
          "--enable-mbstring",
        ]
      end
    end
  end
end
=end