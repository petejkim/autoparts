module Autoparts
  module Packages
    class Ag < Package
      name 'ag'
      version '0.15'
      description 'A code-searching tool similar to ack, but faster.'
      source_url 'https://github.com/ggreer/the_silver_searcher/archive/0.15.tar.gz'
      source_sha1 '578adf5276a9bf39deb7dbaf86abca96c312a388'
      source_filetype 'tar.gz'
      binary_url 'http://nitrousio-autoparts-use1.s3.amazonaws.com/ag-0.15-binary.tar.gz'
      binary_sha1 'b954dcb0c4d0041a5153cc1289ffc2b10d0077d5'

      def install
        Dir.chdir('the_silver_searcher-0.15') do
          execute 'make', 'install'
        end
      end
      
      def compile
        Dir.chdir('the_silver_searcher-0.15') do
          execute "aclocal"
          execute "autoconf"
          execute "autoheader"
          execute "automake --add-missing"
          execute "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix_path}"
          execute "make"
        end
      end
    end
  end
end
