module Autoparts
  module Packages
    class Uuid < Package
      name 'uuid'
      version '1.6.2'
      description 'OSSP uuid: a ISO-C:1999 application programming interface (API) and corresponding command line interface (CLI) for the generation of DCE 1.1, ISO/IEC 11578:1996 and RFC 4122 compliant Universally.'
      category Category::LIBRARIES

      source_url 'ftp://ftp.ossp.org/pkg/lib/uuid/uuid-1.6.2.tar.gz'
      source_sha1 '3e22126f0842073f4ea6a50b1f59dcb9d094719f'
      source_filetype 'tar.gz'

      def compile
        Dir.chdir(name_with_version) do
          args = [
            "--prefix=#{prefix_path}",
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
        Dir.chdir(name_with_version) do
          execute 'make install'
        end
      end
    end
  end
end