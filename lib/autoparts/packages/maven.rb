module Autoparts
  module Packages
    class Maven < Package
      name 'maven'
      version '3.1.1'
      description 'Maven: A software project management and comprehension tool'
      source_url 'http://www.us.apache.org/dist/maven/maven-3/3.1.1/binaries/apache-maven-3.1.1-bin.tar.gz'
      source_sha1 '630eea2107b0742acb315b214009ba08602dda5f'
      source_filetype 'tar.gz'

      def install
        Dir.chdir('apache-maven-3.1.1') do
          prefix_path.mkpath
          execute 'rm', 'bin/mvn.bat'
          execute 'rm', 'bin/mvnDebug.bat'
          execute "mv * #{prefix_path}"
        end
      end
    end
  end
end
