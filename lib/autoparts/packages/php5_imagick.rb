# Copyright (c) 2013-2014 Application Craft Ltd. Codio
# This software is licensed under the [BSD 2-Clause license](https://raw.github.com/codio/boxparts/master/LICENSE).

require 'autoparts/packages/php5_ext'

module Autoparts
  module Packages
    class Php5Imagick < Php5Ext
      name 'php5-imagick'
      category Category::WEB_DEVELOPMENT

      def version
        '3.1.2'
      end

      description 'ImageMagick module for php5'

      def source_url
        'http://pecl.php.net/get/imagick-3.1.2.tgz'
      end

      def source_sha1
        '7cee88bc8f6f178165c9d43e302d99cedfbb3dff'
      end

      def source_filetype
        'tgz'
      end

      depends_on 'php5'
      depends_on 'image_magick'

      def php_extension_name
        "imagick"
      end

      def php_extension_dir
        "imagick-3.1.2"
      end

      def php_compile_args
        [
          "--with-imagick=#{get_dependency("image_magick").prefix_path}",
        ]
      end

    end
  end
end
