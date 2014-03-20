# This package (aka part) is an example which will help guide you build a new
# Autoparts package.

# In order to create a new package you will need to provide the following
# information when creating a pull request:

# * Package Name
# * Version
# * Description
# * Category (A list of categories can be found within [lib/autoparts/category.rb](https://github.com/nitrous-io/autoparts/blob/master/lib/autoparts/category.rb))
# * Source URL (official release source which package will always be located at)
# * Source filetype (the extension of the source file)
# * SHA-1 hash of the source package (You can run `sha1sum` against the source file or [generate](http://hash.online-convert.com/sha1-generator) a SHA-1 hash with the source file)
# * Dependencies (if any)
# * Compile / Installation commands

# Let's take a look at an existing part, MySQL ( https://github.com/action-io/autoparts/blob/master/lib/autoparts/packages/mysql.rb ):

# Naming - Every package should be in the `Autoparts::Packages` module. Give it
# a name and subclass `Package`.

module Autoparts
  module Packages
    class MySQL < Package
      name 'mysql' # This should be the name of the part in all lowercase letters.
      version '5.6.13' # Version of the tool being installed.

      # This description should contain the human readable package name
      # (e.g. 'MySQL'), followed by a colon and then description.
      description "MySQL: The world's most popular open-source relational database"

      # Include a category for your part. A list of categories can be found at
      # https://github.com/nitrous-io/autoparts/blob/master/lib/autoparts/category.rb.
      category Category::DATA_STORES

      # The url of the source archive.
      source_url 'http://dev.mysql.com/get/Downloads/MySQL-5.6/mysql-5.6.13.tar.gz'

      # The sha1 hash. If it is not provided by the host, download the
      # archive and run `sha1sum filename` to obtain this.
      source_sha1 '06e1d856cfb1f98844ef92af47d4f4f7036ef294'

      # source_filetype is used to determine how to extract the package.
      # Currently, variations of tar and zip are supported. Other filetypes are
      # simply copied over without extraction.
      source_filetype 'tar.gz'

      ## Dependencies
      #
      # Include any dependencies for this part.
      # Any dependencies will be installed before proceeding.
      # If any dependencies don't already exist as an Autoparts package, you'll
      # need to add them as a separate package.
      depends_on 'php5' # Not actually needed for MySQL, but added as an example.

      ## Installation
      #
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

      ## Post Install
      #
      # This is the method that gets called after binary/source installs. It's used to do additional setup (e.g. initializing a default db)
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

      def mysql_executable_path
        Path.bin + 'mysql'
      end

      ## Starting and Stopping the part
      #
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
