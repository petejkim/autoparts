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
    class CouchDB < Package
      name 'couchdb' # This should be the name of the part in all lowercase letters.
      version '1.5.1' # Version of the tool being installed.

      # This description should contain the human readable package name
      # (e.g. 'MySQL'), followed by a colon and then description.
      description "CouchDB: A Database for the Web"

      # Include a category for your part. A list of categories can be found at
      # https://github.com/nitrous-io/autoparts/blob/master/lib/autoparts/category.rb.
      category Category::DATA_STORES

      # The url of the source archive.
      source_url 'http://www.apache.org/dist/couchdb/source/1.5.1/apache-couchdb-1.5.1.tar.gz'

      # The sha1 hash. If it is not provided by the host, download the
      # archive and run `sha1sum filename` to obtain this.
      source_sha1 '5340c79f8f9e11742b723f92e2251d4d59b8247c'

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
      depends_on 'erlang' # Not actually needed for MySQL, but added as an example.
      depends_on 'spidermonkey'
      
      ## Installation
      #
      # At this step the archive from the `source_url` is downloaded, and the
      # sha1 hash is checked. Autoparts creates a temporary directory where the
      # archive is unpacked.
      def compile
        Dir.chdir('apache-couchdb-1.5.1') do
          args = [
            "--prefix=#{prefix_path}",
          ]

          execute './configure', *args
          execute 'make'
        end
      end

      def install
        Dir.chdir('apache-couchdb-1.5.1') do
          execute 'make install'
        end
      end

      def couchdb_server_path
        bin_path + 'couchdb'
      end
      
      ## Starting and Stopping the part
      #
      # Some parts run as a service. If your part needs to run in the background
      # then you will need to implement start and stop commands.
      def start
        execute couchdb_server_path, 'start'
      end

      def stop
        execute couchdb_server_path, 'stop'
      end

      # If using start and stop commands, include a 'running?' method.
      def running?
        !!system(couchdb_server_path.to_s, 'status', out: '/dev/null', err: '/dev/null')
      end
      
    end
  end
end