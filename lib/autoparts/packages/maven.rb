module Autoparts
  module Packages
    class Maven < Package
      name 'maven'
      version '3.1.0'
      description 'Maven: A software project management and comprehension tool'
      source_url 'http://www.us.apache.org/dist/maven/maven-3/3.1.0/binaries/apache-maven-3.1.0-bin.tar.gz'
      source_sha1 'af0867027f0907631c1f85ecf668f74c08f5d5e9'
      source_filetype 'tar.gz'
      binary_url 'https://nitrousio-autoparts-use1.s3.amazonaws.com/maven-3.1.0-binary.tar.gz'
      binary_sha1 '724044e8d20d5eccc2c5fd57afb0a4f046c8060c'

      def install
        Dir.chdir('apache-maven-3.1.0') do
          prefix_path.mkpath
          execute 'cp', '-R', '.', prefix_path
        end
      end
    end
  end
end
