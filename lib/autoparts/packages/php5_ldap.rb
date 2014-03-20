require 'autoparts/packages/php5_ext'

module Autoparts
  module Packages
    class Php5Ldap < Package
      include Php5Ext

      name 'php5-ldap'
      description 'ldap module for php5'
      category Category::WEB_DEVELOPMENT

      depends_on 'php5'

      def php_extension_name
        'ldap'
      end

      def php_compile_args
        [
          "--with-libdir=lib/x86_64-linux-gnu/",
        ]
      end
    end
  end
end