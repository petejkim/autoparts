This package (aka part) is a example which will help guide you build a new Autoparts package.

In order to create a new package you will need to provide the following information when creating a pull request:

* Package Name
* Version
* Description
* Source URL (official release source which package will always be located at)
* Filetype (the extension of the file)
* SHA-1 hash (hash should be available on same page as package. If not you can [generate](http://hash.online-convert.com/sha1-generator) a SHA-1 hash with the source file)
* Dependencies (if any)
* Compile / Installation commands

Let's take a look at an existing part, MySQL ( https://github.com/action-io/autoparts/blob/master/lib/autoparts/packages/mysql.rb ):

Naming - Every package should start with `module Autoparts` and `module Packages`.
Your class should be nested within these modules, and named with the first letter 
capitalized (e.g. class Mysql). It should be a class of the type `Package`.

    module Autoparts
      module Packages
        class MySQL < Package
          name 'mysql' # This should be the name of the part in all lowercase letters.
          version '5.6.13' # Please specify the version of the tool being installed.
          description "MySQL: The world's most popular open-source relational database" # This description will display when viewing available parts with `parts search`.

          # The url of the archive (https preferrable):

          source_url 'http://dev.mysql.com/get/Downloads/MySQL-5.6/mysql-5.6.13.tar.gz'

          # The sha1 hash. If it is not provided by the host, download the 
          # archive and run `shasum filename` to obtain this.

          source_sha1 '06e1d856cfb1f98844ef92af47d4f4f7036ef294'

          # Specify the filetype being used. This will generally be the file extension, 
          # but in some scenarios it will differ (e.g. 'php' filetype for '*.phar' files)

          source_filetype 'tar.gz'

          ## Dependencies

          # Include any dependencies for this part.
          # Any dependencies will be installed before proceeding.

          depends_on 'php5' # Not actually needed for MySQL, but added as an example.

          ## Installation

          # At this step the archive from the `source_url` is downloaded, and the 
          # sha1 hash is checked. Autoparts creates a temporary directory where the 
          # archive is unpacked.

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

          # When building paths, you can utilize `+` or `/`.
          # Note that you cannot nest more than two `/` when building a path.

          ## Post Install

          # Utilized to delete any temporary data created in the install process.
          # The archived file in ~/.parts/archives/ may be left in directory for future re-installs

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

          ## Adding to PATH
          # This method is only needed if you need to run the tool within the command line.

          def mysql_executable_path
            Path.bin + 'mysql'
          end

          ## Starting and Stopping the part
          # Some parts run as a service. If your part needs to run in the background  
          # then you will need to implement start and stop commands.

          def start
            execute mysql_server_path, 'start'
          end

          def stop
            execute mysql_server_path, 'stop'
          end

          # If using start and stop commands, include a 'running?' method.

          def running?
            !!system(mysql_server_path.to_s, 'status', out: '/dev/null', err: '/dev/null')
          end
          
          ## Tips
          # If you want to print out any messages after the part has been installed, now is the time.

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
