module Autoparts
  module Packages
    class PostgreSQL < Package
      name 'postgresql'
      version '9.2.4'
      description "PostgreSQL: The world's most advanced open-source database system"
      source_url 'http://ftp.postgresql.org/pub/source/v9.2.4/postgresql-9.2.4.tar.gz'
      source_sha1 'bb248bd2043caf47f2b43c874bf11d775f99e991'
      source_filetype 'tar.gz'
      binary_url 'http://nitrousio-autoparts-use1.s3.amazonaws.com/postgresql-9.2.4-binary.tar.gz'
      binary_sha1 '715b4204f3bd9bfe7ad951cedfc5360ecf14043f'

      def compile
        Dir.chdir('postgresql-9.2.4') do
          args = [
            '--disable-debug',
            "--prefix=#{prefix_path}",
            "--bindir=#{bin_path}",
            "--sysconfdir=#{Path.etc}",
            "--libdir=#{lib_path}",
            "--includedir=#{include_path}",
            "--datarootdir=#{share_path}/#{name}",
            "--datadir=#{share_path}/#{name}",
            "--mandir=#{man_path}",
            "--docdir=#{doc_path}",
            '--enable-thread-safety',
            '--with-gssapi',
            '--with-krb5',
            '--with-libxml',
            '--with-libxslt',
            '--with-openssl'
          ]

          execute './configure', *args
          execute 'make world'
        end
      end

      def install
        Dir.chdir('postgresql-9.2.4') do
          execute 'make install-world'
        end
      end

      def post_install
        postgres_log_path.mkpath
        unless postgres_db_path.exist?
          postgres_db_path.mkpath
          begin
            execute "#{bin_path}/initdb", postgres_db_path
          rescue => e
            postgres_db_path.rmtree
            raise e
          end
          postgres_conf = postgres_db_path + 'postgresql.conf'
          execute 'sed', '-i', "s|#listen_addresses = 'localhost'|listen_addresses = '127.0.0.1'|g", postgres_conf
          execute 'sed', '-i', "s|#port = 5432|port = 5432|g", postgres_conf
          execute 'sed', '-i', "s|#unix_socket_directory = ''|unix_socket_directory = '/tmp'|g", postgres_conf
          start
          print 'creating database "action"....'
          sleep 1 # even though -w option is given, sometimes we can't connect right away
          begin
            execute "#{bin_path}/createdb", '-h', '/tmp'
            puts " done"
          rescue => e
            postgres_db_path.rmtree
            stop
            raise e
          end
          stop
        end
      end

      def postgres_db_path
        Path.var + 'postgresql'
      end

      def postgres_log_path
        Path.var + 'log' + 'postgresql'
      end

      def pg_ctl_path
        Path.bin + 'pg_ctl'
      end

      def start
        raise StartFailedError.new "#{name} is already running." if running?
        execute pg_ctl_path, '-D', postgres_db_path, '-l', "#{postgres_log_path}/postgresql.log", '-w', 'start'
      end

      def stop
        raise StopFailedError.new "#{name} does not seem to be running." unless running?
        execute pg_ctl_path, '-D', postgres_db_path, 'stop'
      end

      def running?
        !!system(pg_ctl_path.to_s, '-D', postgres_db_path.to_s, 'status', out: '/dev/null', err: '/dev/null')
      end

      def tips
        <<-EOS.unindent
          To start the server:
            $ parts start postgresql

          To stop the server:
            $ parts stop postgresql

          To connect to the server:
            $ psql
        EOS
      end
    end
  end
end
