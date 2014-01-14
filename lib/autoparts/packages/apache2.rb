module Autoparts
  module Packages
    class Apache2 < Package
      name 'apache2'
      version '2.4.7'
      description 'Apache HTTP Web Server'
      source_url 'http://mirror.nus.edu.sg/apache//httpd/httpd-2.4.7.tar.gz'
      source_sha1 '9a73783b0f75226fb2afdcadd30ccba77ba05149'
      source_filetype 'tar.gz'
      #binary_url 'https://nitrousio-autoparts-use1.s3.amazonaws.com/ant-1.9.2-binary.tar.gz'
      #binary_sha1 '2f859fd12311552c5d64c2ee2fbdc0843c16a316'
      #
      #depends_on 'apr'
      #depends_on 'apr_util'

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
          prefix_path.mkpath
          execute './configure', *args
          execute 'make'
        end
      end

      def install
        Dir.chdir('httpd-2.4.7') do
          execute 'make install'
        end
      end
    end
  end
end
