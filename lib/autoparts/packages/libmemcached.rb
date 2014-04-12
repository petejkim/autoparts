module Autoparts
  module Packages
    class Libmemcached < Package
      name 'libmemcached' # This should be the name of the part in all lowercase letters.
      version '1.0.18' # Version of the tool being installed.

      # This description should contain the human readable package name
      # (e.g. 'MySQL'), followed by a colon and then description.
      description "libmemcached - A C and C++ client library for memcached"

      # Include a category for your part. A list of categories can be found at
      # https://github.com/nitrous-io/autoparts/blob/master/lib/autoparts/category.rb.
      category Category::LIBRARIES

      # The url of the source archive.
      source_url 'https://launchpad.net/libmemcached/1.0/1.0.18/+download/libmemcached-1.0.18.tar.gz'

      # The sha1 hash. If it is not provided by the host, download the
      # archive and run `sha1sum filename` to obtain this.
      source_sha1 '8be06b5b95adbc0a7cb0f232e237b648caf783e1'

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
      depends_on 'memcached' # Not actually needed for MySQL, but added as an example.

      ## Installation
      #
      # At this step the archive from the `source_url` is downloaded, and the
      # sha1 hash is checked. Autoparts creates a temporary directory where the
      # archive is unpacked.
      def compile
        Dir.chdir('libmemcached-1.0.18') do
          args = [
            "--prefix=#{prefix_path}",
	   "--enable-sasl",
          ]

          execute './configure', *args
          execute 'make'
        end
      end

      def install
        Dir.chdir('libmemcached-1.0.18') do
          execute 'make install'
        end
      end


      def purge
        lib_path.rmtree if lib_path.exist?
      end

      def lib_path
        prefix_path 
      end


      ## Tips
      # If you want to print out any messages after the part has been installed, now is the time.
      def tips
        <<-STR.unindent
installed
STR
      end
    end
  end
end
