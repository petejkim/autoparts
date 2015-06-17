module Autoparts
  module Packages
    class ImageMagick < Package
      name 'image_magick'
      version '6.8.8-7'
      description 'ImageMagick: a software suite to create, edit, compose, or convert bitmap images.'
      category Category::UTILITIES

      source_url 'http://www.imagemagick.org/download/ImageMagick-6.9.1-5.tar.gz'
      source_sha1 'f61dd97b395879972b46d1af1f8617bb1bae40d9'
      source_filetype 'tar.gz'

      def compile
        Dir.chdir('ImageMagick-6.9.1-5') do
          args = [
            "--prefix=#{prefix_path}"
          ]
          execute './configure', *args
          execute 'make'
        end
      end

      def install
        Dir.chdir('ImageMagick-6.9.1-5') do
          execute 'make', 'install'
        end
      end

      def image_magick_path
        bin_path + 'image_magick'
      end
    end
  end
end
