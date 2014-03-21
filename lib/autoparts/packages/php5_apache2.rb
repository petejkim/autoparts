require 'autoparts/packages/php5_ext'


module Autoparts
  module Packages
    class Php5Apache2 < Package
      name 'php5-apache2'
      version '5.5.10'
      description 'Php5 Apache: a php5 module for apache2.'
      source_url 'http://us1.php.net/get/php-5.5.10.tar.gz/from/this/mirror'
      source_sha1 'fa13e3634373791a8cb427d43ab4dcf9fcb3e526'
      source_filetype 'tar.gz'
      category Category::WEB_DEVELOPMENT

      depends_on 'apache2'
      depends_on 'php5'
      depends_on 'libmcrypt'

      def compile
        apache2_libphp5_path.unlink if apache2_libphp5_path.exist?
        Dir.chdir("php-5.5.10") do
          args = [
            "--with-apxs2=#{apache2_dependency.bin_path + "apxs"}",
            "--with-mcrypt=#{get_dependency("libmcrypt").prefix_path}",
            # path
            "--prefix=#{prefix_path}",
            "--bindir=#{bin_path}",
            "--sbindir=#{bin_path}",
            "--with-config-file-path=#{php5_ini_path}",
            "--with-config-file-scan-dir=#{php5_ini_path_additional}",
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
            "--with-mysql",
            "--with-mysqli",
          ]
          execute './configure', *args
          execute 'make'
        end
      end

      def install
        Dir.chdir("php-5.5.10") do
          lib_path.mkpath
          execute 'cp', 'php.ini-development', "#{lib_path}/php.ini"
          # force apache2 to rewrite its config to get a pristine config
          # because php will rewrite it
          apache2_dependency.rewrite_config
          # copy libphp5.so over to the package so it will be distributed with
          # the binary
          execute 'mv', 'libs/libphp5.so', lib_path + "libphp5.so"
        end
      end

      def post_install
        # copy libphp5.so over to apache modules path
        execute 'cp', lib_path + "libphp5.so", apache2_libphp5_path
        # write php5_config if not exist
        unless apache2_php5_config_path.exist?
          File.open(apache2_php5_config_path, "w") { |f| f.write php5_apache_config }
        end
      end

      def post_uninstall
        apache2_libphp5_path.unlink if apache2_libphp5_path.exist?
        apache2_php5_config_path.unlink if apache2_php5_config_path.exist?
      end

      def tips
        <<-EOS.unindent
          PHP config file is located at:
            $ #{php5_ini_path}

          If Apache2 httpd is already running, you will need to restart it:
            $ parts restart apache2
        EOS
      end

      def php5_ini_path
        get_dependency('php5').php5_ini_path
      end

      def php5_ini_path_additional
        get_dependency('php5').php5_ini_path_additional
      end

      def apache2_dependency
        @apache2_dependency ||= get_dependency "apache2"
      end

      def apache2_libphp5_path
        apache2_dependency.prefix_path + "modules" + "libphp5.so"
      end

      def apache2_php5_config_path
        apache2_dependency.user_config_path + "php.conf"
      end

      def php5_apache_config
        <<-EOF.unindent
        PHPIniDir #{php5_ini_path}
        LoadModule php5_module modules/libphp5.so
        AddHandler php5-script .php
        DirectoryIndex index.php
        EOF
      end
    end
  end
end
