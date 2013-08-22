module Autoparts
  module Packages
    class MySQL < Package
      name 'mysql'
      version '5.6.13'
      source_url 'http://dev.mysql.com/get/Downloads/MySQL-5.6/mysql-5.6.13.tar.gz/from/http://cdn.mysql.com/'
      source_sha1 '06e1d856cfb1f98844ef92af47d4f4f7036ef294'
      source_type 'tar.gz'

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
            "-DMYSQL_DATADIR=#{VAR_PATH}/mysql",
            "-DSYSCONFDIR=#{ETC_PATH}",
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
          execute "ln -s #{prefix_path}/support-files/mysql.server #{bin_path}/"
          execute "rm -rf #{prefix_path}/data"
        end
      end

      def post_install
        args = [
          "--basedir=#{prefix_path}",
          "--datadir=#{VAR_PATH}/mysql",
          "--tmpdir=/tmp",
          "--user=#{user}",
          '--verbose'
        ]
        execute "scripts/mysql_install_db", *args
      end

      def tips
        <<-STR.unindent
          To start the server:
            mysql.server start

          To stop the server:
            mysql.server stop

          To connect to the server:
            mysql -uroot
        STR
      end

      def information
        tips
      end
    end
  end
end
