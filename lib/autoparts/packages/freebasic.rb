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
    class FreeBASIC < Package
      name 'freebasic' # This should be the name of the part in all lowercase letters.
      version '1.00.0' # Version of the tool being installed.

      # This description should contain the human readable package name
      # (e.g. 'MySQL'), followed by a colon and then description.
      description "FreeBASIC is a free/open source (GPL), BASIC compiler for Microsoft Windows, DOS and Linux."

      # Include a category for your part. A list of categories can be found at
      # https://github.com/nitrous-io/autoparts/blob/master/lib/autoparts/category.rb.
      category Category::PROGRAMMING_LANGUAGES

      # The url of the source archive.
      source_url 'http://sourceforge.net/projects/fbc/files/Binaries%20-%20Linux/FreeBASIC-1.00.0-linux-x86_64.tar.gz/download'

      # The sha1 hash. If it is not provided by the host, download the
      # archive and run `sha1sum filename` to obtain this.
      source_sha1 '0b653f1d100131828c7b6a4c1fe8f39b437f462c'

      # source_filetype is used to determine how to extract the package.
      # Currently, variations of tar and zip are supported. Other filetypes are
      # simply copied over without extraction.
      source_filetype 'tar.gz'

      ## Installation
      #
      # At this step the archive from the `source_url` is downloaded, and the
      # sha1 hash is checked. Autoparts creates a temporary directory where the
      # archive is unpacked.
      def compile
      end

      def install
        #Dir.chdir('freebasic-1.00.0') do
        prefix_path.mkpath
          Dir.chdir('FreeBASIC-1.00.0-linux-x86_64') do
            execute "./install.sh -i #{prefix_path}"
          end
      end

      ## Post Install
      #
      # This is the method that gets called after binary/source installs. It's used to do additional setup (e.g. initializing a default db)
      # The archived file in ~/.parts/archives/ may be left in directory for future re-installs
      def post_install
       # unless (mysql_var_path + 'mysql' + 'user.frm').exist?
        #  mysql_var_path.rmtree if mysql_var_path.exist?
        ##  ENV['TMPDIR'] = nil
         # args = [
         #   "--basedir=#{prefix_path}",
         #   "--datadir=#{mysql_var_path}",
         #   "--tmpdir=/tmp",
         #   "--user=#{user}",
         #   '--verbose'
         # ]
         # execute "scripts/mysql_install_db", *args
        #end
      end

      def purge
        
      end
    end
  end
end