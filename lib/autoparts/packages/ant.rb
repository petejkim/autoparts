module Autoparts
  module Packages
    class Ant < Package
      name 'ant'
      version '1.9.2'
      description 'Ant: Pure Java build tool, simpler and easier to use than GNU Make'
      source_url 'http://www.us.apache.org/dist//ant/binaries/apache-ant-1.9.2-bin.tar.gz'
      source_sha1 'fa2c18a27cdf407f5d8306bbc0f0b29513d915d8'
      source_filetype 'tar.gz'
      binary_url 'https://nitrousio-autoparts-use1.s3.amazonaws.com/ant-1.9.2-binary.tar.gz'
      binary_sha1 '2f859fd12311552c5d64c2ee2fbdc0843c16a316'

      def install
        Dir.chdir('apache-ant-1.9.2') do
          prefix_path.mkpath
          execute 'rm', '-rf', 'manual', 'INSTALL'
          execute 'cp', '-R', '.', prefix_path
        end
      end
    end
  end
end
