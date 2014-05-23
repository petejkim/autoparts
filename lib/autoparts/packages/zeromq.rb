module Autoparts
  module Packages
    class ZeroMQ < Package
      name 'zeromq'
      version '4.0.4'
      description 'ZeroMQ: Code Connected'
      category Category::LIBRARIES 
      source_url 'http://download.zeromq.org/zeromq-4.0.4.tar.gz'
      source_sha1 '2328014e5990efac31390439b75c5528e38e4490'
      source_filetype 'tar.gz'

      def compile
        Dir.chdir('zeromq-4.0.4') do
          args = [
                  '--prefix=/home/action/.parts',
                  '--exec-prefix=/home/action/.parts']

          execute './configure', *args
          execute 'make'
        end
      end

      def install
        Dir.chdir('zeromq-4.0.4') do
          execute 'make install'
        end
      end

      def post_install
      end

      def purge
      end
    end
  end
end
