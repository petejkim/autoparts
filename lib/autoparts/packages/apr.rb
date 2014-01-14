module Autoparts
  module Packages
    class Apr < Package
      name 'apr'
      version '1.5.0'
      description 'Apache Portable Runtime Project'
      source_url 'http://mirror.nus.edu.sg/apache//apr/apr-1.5.0.tar.gz'
      source_sha1 'c457adf42502a322967ea0499a150587585e5291'
      source_filetype 'tar.gz'

      def compile
        Dir.chdir('apr-1.5.0') do
          args = [
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
          ]

          execute './configure', *args
          execute 'make'
        end
      end


      def install
        Dir.chdir('apr-1.5.0') do
          execute 'make install'
        end
      end
    end
  end
end
