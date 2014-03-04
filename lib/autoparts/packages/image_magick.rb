module Autoparts
  module Packages
    class ImageMagick < Package
      name 'image_magick'
      version '6.8.8-7'
      description 'ImageMagick: a software suite to create, edit, compose, or convert bitmap images.'
      source_url 'http://www.imagemagick.org/download/ImageMagick-6.8.8-7.tar.gz'
      source_sha1 '50e66290c1524de6a6c92e85bd29d33691b18cc7'
      source_filetype 'tar.gz'
      binary_url ''
      binary_sha1 ''
      
      def compile
        Dir.chdir('ImageMagick-6.8.8-7') do
	  args = [
            "--prefix=#{prefix_path}"
          ]
	  execute './configure', *args
          execute 'make'
        end
      end
      
      def install
        Dir.chdir('ImageMagick-6.8.8-7') do
          execute 'make', 'install'
        end
      end
      
      def image_magick_path
        bin_path + 'image_magick'
      end
      
    end
  end
end
