require 'autoparts/packages/php5_ext'

module Autoparts
  module Packages
    class Php5Mongo < Package
      include Php5Ext

      name 'php5-mongo'
      category Category::WEB_DEVELOPMENT

      version '1.4.5'
      description 'Mongo driver for php5'
      source_url 'http://pecl.php.net/get/mongo-1.4.5.tgz'
      source_sha1 'd9608822a3267f24748e9bdef5850e112f0ef54a'
      source_filetype 'tgz'

      depends_on 'php5'

      def php_extension_name
        "mongo"
      end

      def php_extension_dir
        "mongo-#{version}"
      end

    end
  end
end
