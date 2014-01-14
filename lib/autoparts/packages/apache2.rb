module Autoparts
  module Packages
    class Apache2 < Package
      name 'apache2'
      version '2.4.7'
      description 'Apache HTTP Web Server'
      source_url 'http://mirror.nus.edu.sg/apache//httpd/httpd-2.4.7.tar.gz'
      source_sha1 '9a73783b0f75226fb2afdcadd30ccba77ba05149'
      source_filetype 'tar.gz'

      depends_on 'apr'
      depends_on 'apr_util'

      def compile
        Dir.chdir('httpd-2.4.7') do
          args = [
            "--with-apr=#{get_dependency("apr").prefix_path}",
            "--with-apr-util=#{get_dependency("apr_util").prefix_path}",
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
            "--with-mpm=event",
            "--enable-deflate",
            "--enable-expires",
            "--enable-http",
            "--enable-log-debug",
            "--enable-mime-magic",
            "--enable-mods-shared=all",
            "--enable-proxy",
            "--enable-rewrite",
            "--enable-so",
            "--enable-ssl",
          ]
          execute './configure', *args
          execute 'make'
        end
      end

      def install
        Dir.chdir('httpd-2.4.7') do
          execute 'make install'
        end
      end

      def post_install
        unless apache_var_path.exist?
          apache_var_path.mkpath
          conf = Path.etc + "httpd.conf"
          contents = File.read conf
          # enable mod_rewrite
          contents.gsub!(
            "#LoadModule rewrite_module modules/mod_rewrite.so",
            "LoadModule rewrite_module modules/mod_rewrite.so")
          # enable php directive
          unless contents.include?("SetHandler application/x-httpd-php")
            contents += "<FilesMatch \.php$>SetHandler application/x-httpd-php</FilesMatch>"
          end
          File.open(conf, "w") { |f| f.write contents }
          execute "ln", "-s", "#{conf}", apache_conf_path
        end
      end

      def purge
        apache_var_path.rmtree if apache_var_path.exist?
      end

      def apache_conf_path
        apache_var_path + "httpd.conf"
      end

      def apache_var_path
        Path.var + "apache2"
      end

      def httpd_path
        bin_path + 'httpd'
      end

      def start
        execute httpd_path, "-k", "start"
      end

      def stop
        execute httpd_path, "-k", "stop"
      end

      def tips
        <<-EOS.unindent
          To start the server:
            $ parts start apache2

          To stop the server:
            $ parts stop apache2

          Apache config is located at:
            $ #{apache_conf_path}
        EOS
      end
    end
  end
end
