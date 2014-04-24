module Autoparts
  module Packages
    class GraphicsMagick < Package
      name 'graphics_magick'
      version '1.3.19'
      description 'GraphicsMagick: the swiss army knife of image processing.'
      category Category::UTILITIES

      source_url 'http://downloads.sourceforge.net/project/graphicsmagick/graphicsmagick/1.3.19/GraphicsMagick-1.3.19.tar.gz'
      source_sha1 '4176b88a046319fe171232577a44f20118c8cb83'
      source_filetype 'tar.gz'

      def compile
        Dir.chdir('GraphicsMagick-1.3.19') do
          args = [
            "--prefix=#{prefix_path}"
          ]
          execute './configure', *args
          execute 'make'
        end
      end

      def install
        Dir.chdir('GraphicsMagick-1.3.19') do
          execute 'make', 'install'
        end
      end

      def graphics_magick_path
        bin_path + 'graphics_magick'
      end
    end
  end
end
