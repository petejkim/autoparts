require 'autoparts/packages/php5_ext'

module Autoparts
  module Packages
    class Php5Mongo < Php5Ext
      name 'php5-mongo'

      def version
        '1.4.5'
      end

      description 'Mongo driver for php5'

      def source_url
        'http://pecl.php.net/get/mongo-1.4.5.tgz'
      end

      def source_sha1
        'd9608822a3267f24748e9bdef5850e112f0ef54a'
      end

      def source_filetype
        'tgz'
      end

      depends_on 'php5'

      def php_extension_name
        "mongo"
      end

      def php_extension_dir
        "mongo-1.4.5"
      end

      # def php_compile_args
      #   [
      #     "--with-imagick=#{get_dependency("image_magick").prefix_path}",
      #   ]
      # end

    end
  end
end
