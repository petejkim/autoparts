module Autoparts
  module Packages
    class CMake < Package
      name 'cmake'
      version '2.8.11.2'
      description 'CMake: A cross-platform, open-source build system'
      source_url 'http://www.cmake.org/files/v2.8/cmake-2.8.11.2.tar.gz'
      source_sha1 '31f217c9305add433e77eff49a6eac0047b9e929'
      source_filetype 'tar.gz'
      binary_url 'http://nitrousio-autoparts-use1.s3.amazonaws.com/cmake-2.8.11.2-binary.tar.gz'
      binary_sha1 '798a4f1cf0f8c8ba8d2dc3761676cd548b9854e5'

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
