require 'autoparts/packages/php5_ext'

module Autoparts
  module Packages
    class Php5Gd < Package
      include Php5Ext

      name 'php5-gd'
      description 'GD module for php5'
      category Category::WEB_DEVELOPMENT

      depends_on 'php5'

      def php_extension_name
        'gd'
      end

      def php_compile_args
        [
          "--with-jpeg-dir",
          "--with-png",
          # "--with-freetype-dir",
          # " --with-ttf",
          "--with-xpm",
          "--with-freetype",
        ]
      end
    end
  end
end