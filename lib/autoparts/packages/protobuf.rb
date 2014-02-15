module Autoparts
  module Packages
    class Protobuf < Package
      name 'protobuf'
      version '2.5.0'
      description 'Protocol Buffers: language- and platform-neutral mechanism for serializing structured data'
      source_url 'https://protobuf.googlecode.com/files/protobuf-2.5.0.tar.bz2'
      source_sha1 '62c10dcdac4b69cc8c6bb19f73db40c264cb2726'
      source_filetype 'tar.bz2'

      def install
        Dir.chdir('protobuf-2.5.0') do
          execute 'make', 'install'
        end
      end

      def compile
        Dir.chdir('protobuf-2.5.0') do
          args = ["--prefix=#{prefix_path}"]
          execute './configure', *args
          execute 'make'
        end
      end
    end
  end
end
