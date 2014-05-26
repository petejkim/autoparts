

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
    class SpiderMonkey < Package
      name 'spidermonkey' # This should be the name of the part in all lowercase letters.
      version '24.2.0' # Version of the tool being installed.

      # This description should contain the human readable package name
      # (e.g. 'MySQL'), followed by a colon and then description.
      description "SpiderMonkey: Mozilla's JavaScript engine written in C/C++"

      # Include a category for your part. A list of categories can be found at
      # https://github.com/nitrous-io/autoparts/blob/master/lib/autoparts/category.rb.
      category Category::LIBRARIES

      # The url of the source archive.
      source_url 'https://ftp.mozilla.org/pub/mozilla.org/js/mozjs-24.2.0.tar.bz2'

      # The sha1 hash. If it is not provided by the host, download the
      # archive and run `sha1sum filename` to obtain this.
      source_sha1 'ce779081cc11bd0c871c6f303fc4a0091cf4fe66'

      # source_filetype is used to determine how to extract the package.
      # Currently, variations of tar and zip are supported. Other filetypes are
      # simply copied over without extraction.
      source_filetype 'tar.bz2'

      ## Dependencies
      #
      # Include any dependencies for this part.
      # Any dependencies will be installed before proceeding.
      # If any dependencies don't already exist as an Autoparts package, you'll
      # need to add them as a separate package.
      #depends_on 'erlang' # Not actually needed for MySQL, but added as an example.

      ## Installation
      #
      # At this step the archive from the `source_url` is downloaded, and the
      # sha1 hash is checked. Autoparts creates a temporary directory where the
      # archive is unpacked.
      def compile
        Dir.chdir('mozjs-24.2.0/js/src') do
          args = [
            "--prefix=#{prefix_path}"
          ]

          execute './configure', *args
          execute 'make'
        end
      end

      def install
        Dir.chdir('mozjs-24.2.0/js/src') do
          execute 'make', 'install'
        end
      end


    end
  end
end