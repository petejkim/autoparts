module Autoparts
  module Packages
    class MySQL < Package
      name 'mysql'
      version '5.6.13'
      description "MySQL: The world's most popular open-source relational database"
      source_url 'http://dev.mysql.com/get/Downloads/MySQL-5.6/mysql-5.6.13.tar.gz/from/http://cdn.mysql.com/'
      source_sha1 '06e1d856cfb1f98844ef92af47d4f4f7036ef294'
      source_filetype 'tar.gz'

      def compile
        Dir.chdir('mysql-5.6.13') do
          args = [
            '.',
            "-DCMAKE_INSTALL_PREFIX=#{prefix_path}",
            "-DDEFAULT_CHARSET=utf8",
            "-DDEFAULT_COLLATION=utf8_general_ci",
            "-DINSTALL_MANDIR=#{man_path}",
            "-DINSTALL_DOCDIR=#{doc_path}",
            "-DINSTALL_INFODIR=#{info_path}",
            "-DINSTALL_MYSQLSHAREDIR=#{share_path.basename}/#{name}",
            "-DMYSQL_DATADIR=#{Path.var}/mysql",
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
        Dir.chdir('mysql-5.6.13') do
          execute 'make install'
          execute 'rm', '-rf', mysql_server_path
          execute 'ln', '-s', "#{prefix_path}/support-files/mysql.server", "#{bin_path}/"
          execute 'rm', '-rf', "#{prefix_path}/data"
          execute 'rm', '-rf', "#{prefix_path}/mysql-test"
        end
      end

      def post_install
        unless (mysql_var_path + 'mysql' + 'user.frm').exist?
          mysql_var_path.rmtree if mysql_var_path.exist?
          ENV['TMPDIR'] = nil
          args = [
            "--basedir=#{prefix_path}",
            "--datadir=#{mysql_var_path}",
            "--tmpdir=/tmp",
            "--user=#{user}",
            '--verbose'
          ]
          execute "scripts/mysql_install_db", *args
        end
      end

      def purge
        mysql_var_path.rmtree if mysql_var_path.exist?
      end

      def mysql_server_path
        bin_path + 'mysql.server'
      end

      def mysql_var_path
        Path.var + 'mysql'
      end

      def start
        execute mysql_server_path, 'start'
      end

      def stop
        execute mysql_server_path, 'stop'
      end

      def running?
        !!system(mysql_server_path.to_s, 'status', out: '/dev/null', err: '/dev/null')
      end

      def tips
        <<-STR.unindent
          To start the server:
            $ parts start mysql

          To stop the server:
            $ parts stop mysql

          To connect to the server:
            $ mysql
        STR
      end
    end
  end
end
