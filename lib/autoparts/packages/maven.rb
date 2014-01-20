module Autoparts
  module Packages
    class Maven < Package
      name 'maven'
      version '3.1.0'
      description 'Maven: A software project management and comprehension tool'
      source_url 'http://www.us.apache.org/dist/maven/maven-3/3.1.0/binaries/apache-maven-3.1.0-bin.tar.gz'
      source_sha1 'af0867027f0907631c1f85ecf668f74c08f5d5e9'
      source_filetype 'tar.gz'

      def install
        Dir.chdir('apache-maven-3.1.0') do
          prefix_path.mkpath
          execute 'rm', 'bin/mvn.bat'
          execute 'rm', 'bin/mvnDebug.bat'
          execute "mv * #{prefix_path}"
        end
      end
    end
  end
end
