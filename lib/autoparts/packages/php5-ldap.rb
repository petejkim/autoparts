require File.join(File.dirname(__FILE__), 'php5ext')

module Autoparts
  module Packages
    class Php5ExtLdap < Php5Ext
      name 'php5-ldap'
      description 'ldap module for php5'
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