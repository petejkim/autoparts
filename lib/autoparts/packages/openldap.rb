module Autoparts
  module Packages
    class Openldap < Package
      name 'openldap'
      version '2.4.39'
      description 'OpenLDAP:  an open source implementation of the Lightweight Directory Access Protocol.'
      source_url 'ftp://ftp.openldap.org/pub/OpenLDAP/openldap-release/openldap-2.4.39.tgz'
      source_sha1 '2b8e8401214867c361f7212e7058f95118b5bd6c'
      source_filetype 'tgz'
      category Category::UTILITIES

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
        end\
      end

      # Set all ldap utils to connect to port 1389
      def post_install
	open("#{config_path}/ldap.conf", "a") do |conf|
          conf.puts "URI     ldap://localhost:1389"
	end
      end

      def slapd_path
        "#{prefix_path}/libexec/slapd" 
      end

      def config_path
        "#{prefix_path}/etc/openldap"
      end

      def pidfile
        "#{prefix_path}/var/run/slapd.pid"
      end

      def pid
        Integer File.read(pidfile)
      end

      def start
        execute "#{slapd_path} -h ldap://127.0.0.1:1389 -f #{config_path}/slapd.conf"
      end

      def stop
        Process.kill("INT", pid)
      end

      def running?
        begin
          Process.kill 0, pid
        rescue Errno::ENOENT, Errno::ESRCH
          false
        end
      end

      def tips
        <<-STR.unindent
          The server runs on port 1389, rather than the normal 389.
          This is due to port 389 requiring root access to bind to.

          To start the server:
            $ parts start openldap

          To stop the server:
            $ parts stop openldap
        STR
      end
    end
  end
end
