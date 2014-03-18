module Autoparts
  module Packages
    class BerkeleyDb < Package
      name 'berkeley_db'
      version '6.0.30'
      description 'Berkeley DB: a software library that provides a high-performance embedded database for key/value data.'
      source_url 'http://download.oracle.com/berkeley-db/db-6.0.30.NC.tar.gz'
      source_sha1 '15d85cf617f6c5a92212afd457593b0b9167a1fc'
      source_filetype 'tar.gz'


      def compile
        Dir.chdir('db-6.0.30.NC') do
          args = [
            "--prefix=#{prefix_path}",
          ]

          execute 'dist/configure', *args
          execute 'make'
        end
      end

      def install
         Dir.chdir('db-6.0.30.NC') do
          execute 'make', 'install'
        end
      end
    end
  end
end
