module Autoparts
  module Packages
    class Openldap < Package
      name 'openldap'
      version '2.4.39'
      description 'OpenLDAP:  an open source implementation of the Lightweight Directory Access Protocol.'
      source_url 'ftp://ftp.openldap.org/pub/OpenLDAP/openldap-release/openldap-2.4.39.tgz'
      source_sha1 '2b8e8401214867c361f7212e7058f95118b5bd6c'
      source_filetype 'tgz'

      depends_on 'berkeley_db'

      def compile
        Dir.chdir(extracted_archive_path + name_with_version) do
          args = [
            "--prefix=#{prefix_path}",
            "--enable-ldap",
            "--with-tls=openssl"
          ]

          execute './configure', *args
          execute 'make'
        end
      end


      def install
        Dir.chdir(extracted_archive_path + name_with_version) do
          execute 'make install'
        end
      end
    end
  end
end
