require 'autoparts/packages/php5_ext'

module Autoparts
  module Packages
    class Php5Xdebug < Package
      include Php5Ext

      name 'php5-xdebug'
      version '2.2.4-1'
      description 'Xdebug module for php5'
      source_url 'http://pecl.php.net/get/xdebug-2.2.4.tgz'
      source_sha1 '586a7f24330f5139b7b8cec8ed96b99f3d3a753d'
      source_filetype 'tgz'
      category Category::WEB_DEVELOPMENT

      depends_on 'php5'

      def php_extension_name
        "xdebug"
      end

      def php_extension_dir
        "xdebug-#{version}"
      end

      def php_compile_args
        ['--enable-xdebug']
      end

      def extension_config
        <<-EOF.unindent
        zend_extension=#{prefix_path}/#{php_extension_name}.so
        EOF
      end

    end
  end
end
