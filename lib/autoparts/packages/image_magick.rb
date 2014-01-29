module Autoparts
  module Packages
    class ImageMagick < Package
      name 'image_magick'
      version '6.8.8-3'
      description 'ImageMagick: a software suite to create, edit, compose, or convert bitmap images.'
      source_url 'http://www.imagemagick.org/download/ImageMagick-6.8.8-3.tar.gz'
      source_sha1 '10b8e742b294967e783a21bbdc62d650df49458a'
      source_filetype 'tar.gz'

      def compile
        Dir.chdir('ImageMagick-6.8.8-3') do
	  args = [
            "--prefix=#{prefix_path}"
          ]
	  execute './configure', *args
          execute 'make'
        end
      end

      def install
        Dir.chdir('ImageMagick-6.8.8-3') do
          execute 'make', 'install'
        end
      end

      def image_magick_path
        bin_path + 'image_magick'
      end

    end
  end
end
