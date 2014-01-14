module Autoparts
  module Packages
    class Php5 < Package
      name 'php5'
      version '5.5.8'
      description 'PHP 5.5'
      source_url "http://us1.php.net/get/php-5.5.8.tar.gz/from/this/mirror"
      source_sha1 '19af9180c664c4b8f6c46fc10fbad9f935e07b52'
      source_filetype 'tar.gz'

      depends_on 'apache2'
      depends_on 'libmcrypt'

      def compile
        Dir.chdir('php-5.5.8') do
          args = [
            "--with-apxs2=#{get_dependency("apache2").bin_path + "apxs"}",
            # path
            "--prefix=#{prefix_path}",
            "--bindir=#{bin_path}",
            "--sbindir=#{bin_path}",
            "--sysconfdir=#{Path.etc}",
            "--libdir=#{lib_path}",
            "--includedir=#{include_path}",
            "--datarootdir=#{share_path}/#{name}",
            "--datadir=#{share_path}/#{name}",
            "--mandir=#{man_path}",
            "--docdir=#{doc_path}",
            # features
            "--enable-opcache",
            "--with-mcrypt=#{get_dependency("libmcrypt").prefix_path}",
            "--with-mysql",
            "--with-openssl",
            "--with-pgsql",
            "--with-readline",
          ]
          execute './configure', *args
          execute 'make'
        end
      end

      def install
        Dir.chdir('php-5.5.8') do
          execute 'make install'
          execute 'cp', 'php.ini-development', "#{lib_path}/php.ini"
        end
      end

      def post_install
        unless php5_var_path.exist?
          php5_var_path.mkpath
          execute 'ln', '-s', "#{lib_path}/php.ini", "#{php5_var_path + ""}/php.ini"
        end
      end

      def purge
        php5_var_path.rmtree if php5_var_path.exist?
      end

      def php5_var_path
        Path.var + "php5"
      end
    end
  end
end
