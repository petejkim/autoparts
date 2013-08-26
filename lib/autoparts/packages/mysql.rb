module Autoparts
  module Packages
    class MySQL < Package
      name 'mysql'
      version '5.6.13'
      source_url 'http://dev.mysql.com/get/Downloads/MySQL-5.6/mysql-5.6.13.tar.gz/from/http://cdn.mysql.com/'
      source_sha1 '06e1d856cfb1f98844ef92af47d4f4f7036ef294'
      source_filetype 'tar.gz'
      binary_url 'http://nitrousio-autoparts-use1.s3.amazonaws.com/mysql-5.6.13-binary.tar.gz'
      binary_sha1 '7bf6ecd2138923043c6018f57af5307765e72b8c'

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
          execute "ln -s #{prefix_path}/support-files/mysql.server #{bin_path}/"
          execute "rm -rf #{prefix_path}/data"
        end
      end

      def post_install
        unless (Path.var + 'mysql' + 'mysql' + 'user.frm').exist?
          ENV['TMPDIR'] = nil
          args = [
            "--basedir=#{prefix_path}",
            "--datadir=#{Path.var}/mysql",
            "--tmpdir=/tmp",
            "--user=#{user}",
            '--verbose'
          ]
          execute "scripts/mysql_install_db", *args
        end
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
