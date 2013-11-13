module Autoparts
  module Packages
    class ImageMagick < Package
      name 'image_magick'
      version '6.8.7-5'
      description 'ImageMagick: a software suite to create, edit, compose, or convert bitmap images.'
      source_url 'http://www.imagemagick.org/download/ImageMagick-6.8.7-5.tar.gz'
      source_sha1 'bfc03a14a95e13a25669f23dde915d5d7331e74f'
      source_filetype 'tar.gz'
      binary_url ''
      binary_sha1 ''
      
      def compile
        Dir.chdir('ImageMagick-6.8.7-5') do
	  args = [
            "--prefix=#{prefix_path}"
          ]
	  execute './configure', *args
          execute 'make'
        end
      end
      
      def install
        Dir.chdir('ImageMagick-6.8.7-5') do
          execute 'make', 'install'
        end
      end
      
      def image_magick_path
        bin_path + 'image_magick'
      end
      
    end
  end
end
