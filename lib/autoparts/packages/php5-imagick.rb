module Autoparts
  module Packages
    class Php5ExtIMagic < Package
      name 'php5-imagick'
      version '3.1.2'
      description 'ImageMagick module for php5'
      source_url 'http://pecl.php.net/get/imagick-3.1.2.tgz'
      source_sha1 '7cee88bc8f6f178165c9d43e302d99cedfbb3dff'
      source_filetype 'tgz'

      depends_on 'php5'
      depends_on 'image_magick'

      def compile
        Dir.chdir('imagick-3.1.2') do
          args = [
            "--with-imagick=#{get_dependency("image_magick").prefix_path}",
          ]
          execute 'phpize'
          execute './configure', *args
          execute 'make'
        end
      end

      def extension_config_path
        get_dependency("php5").php5_ini_path_additional + "imagick.ini"
      end

      def extension_config
        <<-EOF.unindent
        extension=#{prefix_path}/imagick.so
        EOF
      end

      def install
        FileUtils.mkdir_p(prefix_path)
        Dir.chdir('imagick-3.1.2/modules') do
          execute 'cp', 'imagick.so', "#{prefix_path}"
          execute 'cp', 'imagick.la', "#{prefix_path}"
        end
      end

      def post_install
          File.open(extension_config_path, "w") { |f| f.write extension_config }
      end

      def post_uninstall
        extension_config_path.unlink if extension_config_path.exist?
      end
    end
  end
end
