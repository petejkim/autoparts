module Autoparts
  module Packages
    class ZeroMQ < Package
      name 'zeromq'
      version '4.0.4'
      description 'ZeroMQ: A high-performance asynchronous messaging library'
      category Category::LIBRARIES
      source_url 'http://download.zeromq.org/zeromq-4.0.4.tar.gz'
      source_sha1 '2328014e5990efac31390439b75c5528e38e4490'
      source_filetype 'tar.gz'

      def compile
        Dir.chdir(name_with_version) do
          args = [
            "--prefix=#{prefix_path}",
            "--exec-prefix=#{prefix_path}",
          ]

          execute './configure', *args
          execute 'make'
        end
      end

      def install
        Dir.chdir(name_with_version) do
          execute 'make install'
        end
      end
    end
  end
end
