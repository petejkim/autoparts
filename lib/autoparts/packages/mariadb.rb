module Autoparts
  module Packages
    class Mariadb < Package
      name 'mariadb'
      version '5.5.36'
      description "MariaDB: An enhanced, drop-in replacement for MySQL."
      source_url 'http://mirror.mephi.ru/mariadb/mariadb-5.5.36/kvm-tarbake-jaunty-x86/mariadb-5.5.36.tar.gz'
      source_sha1 'a6091356ffe524322431670ad03d68c389243d04'
      source_filetype 'tar.gz'
      category Category::DATA_STORES

      def compile
        Dir.chdir(name_with_version) do
          args = [
            '.',
            "-DCMAKE_INSTALL_PREFIX=#{prefix_path}",
            "-DDEFAULT_CHARSET=utf8",
            "-DDEFAULT_COLLATION=utf8_general_ci",
            "-DINSTALL_MANDIR=#{man_path}",
            "-DINSTALL_DOCDIR=#{doc_path}",
            "-DINSTALL_INFODIR=#{info_path}",
            "-DINSTALL_MYSQLSHAREDIR=#{share_path.basename}/mysql",
            "-DMYSQL_DATADIR=#{Path.var}/mariadb",
            "-DSYSCONFDIR=#{Path.etc}",
            "-DWITH_READLINE=yes",
            "-DWITH_SSL=yes",
            "-DWITH_UNIT_TESTS=OFF"
          ]

          execute 'cmake', *args
          execute 'make'
        end
      end

      def install
        Dir.chdir(name_with_version) do
          execute 'make install'
          execute 'rm', '-rf', mariadb_server_path
          execute 'ln', '-s', "#{prefix_path}/support-files/mysql.server", "#{bin_path}/"
          execute 'rm', '-rf', "#{prefix_path}/data"
          execute 'rm', '-rf', "#{prefix_path}/mysql-test"
        end
      end

      def post_install
        unless (mariadb_var_path + 'mariadb' + 'user.frm').exist?
          mariadb_var_path.rmtree if mariadb_var_path.exist?
          ENV['TMPDIR'] = nil
          args = [
            "--basedir=#{prefix_path}",
            "--datadir=#{mariadb_var_path}",
            "--tmpdir=/tmp",
            "--user=#{user}",
            '--verbose'
          ]
          execute "#{prefix_path}/scripts/mysql_install_db", *args
        end
      end

      def purge
        mariadb_var_path.rmtree if mariadb_var_path.exist?
      end

      def mariadb_server_path
        bin_path + 'mysql.server'
      end

      def mariadb_var_path
        Path.var + 'mariadb'
      end

      def start
        execute mariadb_server_path, 'start'
      end

      def stop
        execute mariadb_server_path, 'stop'
      end

      def running?
        !!system(mariadb_server_path.to_s, 'status', out: '/dev/null', err: '/dev/null')
      end

      def tips
        <<-STR.unindent
          To start the server:
            $ parts start mariadb

          To stop the server:
            $ parts stop mariadb

          To connect to the server:
            $ mysql
        STR
      end
    end
  end
end
