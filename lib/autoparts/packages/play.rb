module Autoparts
  module Packages
    class Play < Package
      name 'play'
      version '2.1.3'
      description 'Play: A web framework for Java and Scala'
      source_url 'http://downloads.typesafe.com/play/2.1.3/play-2.1.3.zip'
      source_sha1 'f399da960980edc929011c07ef64ee868eca8a9f'
      source_filetype 'zip'
      binary_url 'https://nitrousio-autoparts-use1.s3.amazonaws.com/play-2.1.3-binary.tar.gz'
      binary_sha1 '9cce9c30158ef887b15c5e71b45cb90ad8008cf9'

      def install
        Dir.chdir('play-2.1.3') do
          prefix_path.mkpath
          execute 'cp', '-R', '.', prefix_path
        end
      end

      def post_install
        execute 'chmod', '0755', play_executable_path
        bin_path.mkpath
        execute 'ln', '-s', play_executable_path, (bin_path + 'play')
      end

      def play_executable_path
        prefix_path + 'play'
      end
    end
  end
end
