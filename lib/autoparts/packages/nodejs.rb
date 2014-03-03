module Autoparts
  module Packages
    class Nodejs < Package
      name 'nodejs'
      version '0.10.26'
      description 'NodeJs: Node\'s goal is to provide an easy way to build scalable network programs'
      source_url 'http://nodejs.org/dist/v0.10.26/node-v0.10.26.tar.gz'
      source_sha1 '2340ec2dce1794f1ca1c685b56840dd515a271b2'
      source_filetype 'tar.gz'

      def compile
        Dir.chdir('node-v0.10.26') do
          args = [
            # path
            "--prefix=#{prefix_path}",
          ]
          execute './configure', *args
          execute 'make'
        end
      end

      def install
        Dir.chdir('node-v0.10.26') do
          execute 'make install'
        end
      end
    end
  end
end