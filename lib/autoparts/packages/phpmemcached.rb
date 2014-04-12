module Autoparts
  module Packages
    class Phpmemcached < Package
      name 'phpmemcached' # This should be the name of the part in all lowercase letters.
      version '2.1.0' # Version of the tool being installed.

      # This description should contain the human readable package name
      # (e.g. 'MySQL'), followed by a colon and then description.
      description "php-memcached extentions"

      # Include a category for your part. A list of categories can be found at
      # https://github.com/nitrous-io/autoparts/blob/master/lib/autoparts/category.rb.
      category Category::LIBRARIES

      # The url of the source archive.
      source_url 'http://pecl.php.net/get/memcached-2.1.0.tgz'

      # The sha1 hash. If it is not provided by the host, download the
      # archive and run `sha1sum filename` to obtain this.
      source_sha1 '16fac6bfae8ec7e2367fda588b74df88c6f11a8e'

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
      depends_on 'libmemcached' # Not actually needed for MySQL, but added as an example.

      ## Installation
      #
      # At this step the archive from the `source_url` is downloaded, and the
      # sha1 hash is checked. Autoparts creates a temporary directory where the
      # archive is unpacked.
      def compile
        Dir.chdir('memcached-2.1.0') do
          args = [
            "--prefix=#{prefix_path}",
	    "--with-libmemcached-dir=#{get_dependency("libmemcached").prefix_path}",
            "--disable-memcached-sasl"
          ]
	  execute 'phpize'
          execute './configure', *args
          execute 'make'
        end
      end

      def install
        Dir.chdir('memcached-2.1.0') do
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
Add this line to the end of file 'php.ini' (Depend on your php version)
extension=/home/action/.parts/packages/php5/5.5.8-nitrous2/lib/extensions/no-debug-zts-20121212/memcached.so
STR
      end
    end
  end
end
