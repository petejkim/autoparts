# Copyright (c) 2013-2014 Irrational Industries Inc. d.b.a. Nitrous.IO
# This software is licensed under the [BSD 2-Clause license](https://raw.github.com/nitrous-io/autoparts/master/LICENSE).

module Autoparts
  module Packages
    class PostgreSQL < Package
      name 'postgresql'
      version '9.3.5'
      description "PostgreSQL: The world's most advanced open-source database system"
      category Category::DATA_STORES

      source_url 'https://ftp.postgresql.org/pub/source/v9.3.5/postgresql-9.3.5.tar.gz'
      source_sha1 'f5a888aaba98d637fa6cdf009aebcda10d53d038'
      source_filetype 'tar.gz'

      depends_on 'uuid'
      
      def compile
        Dir.chdir(name_with_version) do
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
            '--with-openssl',
            '--with-ossp-uuid',
          ]

          execute './configure', *args
          execute 'make world'
        end
      end

      def install
        Dir.chdir(name_with_version) do
          execute 'make install-world'
        end
      end

      def post_install
        postgres_log_path.mkpath
        unless postgres_var_path.exist?
          postgres_var_path.mkpath
          begin
            execute "#{bin_path}/initdb", postgres_var_path
          rescue => e
            postgres_var_path.rmtree if postgres_var_path.exist?
            raise e
          end
          postgres_conf = postgres_var_path + 'postgresql.conf'
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
            postgres_var_path.rmtree if postgres_var_path.exist?
            stop
            raise e
          end
          stop
        end
      end

      def purge
        postgres_var_path.rmtree if postgres_var_path.exist?
        postgres_log_path.rmtree if postgres_log_path.exist?
      end

      def postgres_var_path
        Path.var + 'postgresql'
      end

      def postgres_log_path
        Path.var + 'log' + 'postgresql'
      end

      def pg_ctl_path
        bin_path + 'pg_ctl'
      end

      def start
        execute pg_ctl_path, '-D', postgres_var_path, '-l', "#{postgres_log_path}/postgresql.log", '-w', 'start'
      end

      def stop
        execute pg_ctl_path, '-D', postgres_var_path, 'stop'
      end

      def running?
        !!system(pg_ctl_path.to_s, '-D', postgres_var_path.to_s, 'status', out: '/dev/null', err: '/dev/null')
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