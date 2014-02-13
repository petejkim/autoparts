require File.join(File.dirname(__FILE__), 'php5ext')

module Autoparts
  module Packages
    class Php5ExtImap < Php5Ext
      name 'php5-imap'
      description 'IMAP module for php5'
      depends_on 'php5'

      def php_extension_name
        'imap'
      end

      def php_compile_args
        [
          "--with-kerberos",
          "--with-imap-ssl",
        ]
      end
    end
  end
end