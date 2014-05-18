# Copyright (c) 2013-2014 Irrational Industries Inc. d.b.a. Nitrous.IO
# This software is licensed under the [BSD 2-Clause license](https://raw.github.com/nitrous-io/autoparts/master/LICENSE).

module Autoparts
  module Packages
    class Php5 < Package
      name 'php54'
      version '5.4.28'
      description 'PHP 5.4: A popular general-purpose scripting language that is especially suited to web development.'
      category Category::PROGRAMMING_LANGUAGES

      source_url 'http://us1.php.net/get/php-5.4.28.tar.bz2/from/this/mirror'
      source_sha1 '857d458b0daf89f36f8d652c5d8bd5fe509bc691'
      source_filetype 'tar.bz2'

      depends_on 'apache2'
      depends_on 'libmcrypt'

      def compile
        Dir.chdir("php-#{version}") do
          args = [
            "--with-apxs2=#{apache2_dependency.bin_path + "apxs"}",
            "--with-mcrypt=#{get_dependency("libmcrypt").prefix_path}",
            "--prefix=#{prefix_path}",
            "--with-curlwrappers",
            "--with-gd",
            "--with-jpeg-dir=/usr/lib/x86_64-linux-gnu",
            "--with-png-dir=/usr/lib/x86_64-linux-gnu",
            "--with-freetype-dir=/usr/lib/x86_64-linux-gnu",
            "--enable-gd-native-ttf",
            "--enable-exif",
            "--with-config-file-path=#{php5_ini_path}",
            "--with-config-file-scan-dir=#{php5_scan_path}",
            "--with-zlib",
            "--with-zlib-dir=/usr/lib/x86_64-linux-gnu",
            "--with-gettext",
            "--with-kerberos",
            "--with-iconv",
            "--enable-sockets",
            "--with-openssl",
            "--with-pdo-mysql=mysqlnd",
            "--with-pdo-sqlite",
            "--with-mysql=mysqlnd",
            "--with-mysql-sock=/tmp/mysql.sock",
            "--with-mysqli=mysqlnd",
            "--enable-soap",
            "--enable-xmlreader",
            "--with-xsl",
            "--with-curl",
            "--enable-mbstring",
            "--with-pgsql",
            "--with-pdo-pgsql",
            "--with-readline",
            "--enable-zip",
            "--enable-sysvsem",
            "--enable-sysvshm",
            "--enable-json",
            "--enable-bcmath",
            "--enable-intl"

          ]
          execute './configure', *args
          execute 'make'
        end
      end

      def install
        Dir.chdir("php-#{version}") do
          execute 'make install'
          execute 'cp', 'php.ini-development', "#{lib_path}/php.ini"
          # force apache2 to rewrite its config to get a pristine config
          # because php will rewrite it
          apache2_dependency.rewrite_config
          # copy libphp5.so over to the package so it will be distributed with
          # the binary
          execute 'mv', "#{apache2_libphp5_path}", "#{lib_path + "libphp5.so"}"
        end
      end

      def post_install
        # copy libphp5.so over to apache modules path
        execute 'cp', "#{lib_path + "libphp5.so"}", "#{apache2_libphp5_path}"
        # write php5_config if not exist
        unless apache2_php5_config_path.exist?
          File.open(apache2_php5_config_path, "w") { |f| f.write php5_apache_config }
        end
        # copy php.ini over
        unless php5_ini_path.exist?
          FileUtils.mkdir_p(File.dirname(php5_ini_path))
          execute 'cp', "#{lib_path}/php.ini", "#{php5_ini_path}"
        end
      end

      def tips
        <<-EOS.unindent
          #{apache2_dependency.tips}

          PHP config file is located at:
            $ #{php5_ini_path}

          If Apache2 httpd is already running, you will need to restart it:
            $ parts restart apache2
        EOS
      end

      def php5_ini_path
        Path.etc + "php5" + "php.ini"
      end

      def php5_scan_path
        Path.etc + "php5" + "conf.d"
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
