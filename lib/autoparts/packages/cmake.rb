module Autoparts
  module Packages
    class CMake < Package
      name 'cmake'
      version '2.8.11.2'
      source_url 'http://www.cmake.org/files/v2.8/cmake-2.8.11.2.tar.gz'
      source_sha1 '31f217c9305add433e77eff49a6eac0047b9e929'
      source_filetype 'tar.gz'

      def compile
        Dir.chdir('cmake-2.8.11.2') do
          execute './bootstrap', "--prefix=#{prefix_path}"
          execute 'make'
        end
      end

      def install
        Dir.chdir('cmake-2.8.11.2') do
          execute 'make install'
        end
      end
    end
  end
end
