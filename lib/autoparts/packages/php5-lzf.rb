require File.join(File.dirname(__FILE__), 'php5ext')

module Autoparts
  module Packages
    class Php5ExtLZF < Php5Ext
      name 'php5-lzf'

      def version
        '1.6.2'
      end

      description 'LZF module for php5'

      def source_url
        'http://pecl.php.net/get/LZF-1.6.2.tgz'
      end

      def source_sha1
        '9e24976b65a000ea09f0860daa1de13d5de4f022'
      end

      def source_filetype
        'tgz'
      end

      depends_on 'php5'

      def php_extension_name
        "lzf"
      end

      def php_extension_dir
        "LZF-1.6.2"
      end

    end
  end
end
