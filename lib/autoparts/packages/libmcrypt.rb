module Autoparts
  module Packages
    class Libmcrypt < Package
      name 'libmcrypt'
      version '2.5.8'
      description 'Libmcrypt: a uniform interface to several symmetric encryption algorithms'
      source_url "http://downloads.sourceforge.net/project/mcrypt/Libmcrypt/2.5.8/libmcrypt-2.5.8.tar.gz"
      source_sha1 '9a426532e9087dd7737aabccff8b91abf9151a7a'
      source_filetype 'tar.gz'

      def compile
        Dir.chdir('libmcrypt-2.5.8') do
          args = [
            # path
            "--prefix=#{prefix_path}",
            "--exec-prefix=#{prefix_path}",
            "--bindir=#{bin_path}",
            "--sbindir=#{bin_path}",
            "--sysconfdir=#{Path.etc}",
            "--libdir=#{lib_path}",
            "--includedir=#{include_path}",
            "--datadir=#{share_path}/#{name}",
            "--mandir=#{man_path}",
          ]
          execute './configure', *args
          execute 'make'
        end
      end

      def install
        Dir.chdir('libmcrypt-2.5.8') do
          execute 'make install'
        end
      end
    end
  end
end
