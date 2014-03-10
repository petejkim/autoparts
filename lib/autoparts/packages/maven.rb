# Copyright (c) 2013-2014 Irrational Industries Inc. d.b.a. Nitrous.IO
# This software is licensed under the [BSD 2-Clause license](https://raw.github.com/nitrous-io/autoparts/master/LICENSE).

module Autoparts
  module Packages
    class Maven < Package
      name 'maven'
      version '3.1.1'
      description 'Maven: A software project management and comprehension tool'
      source_url 'http://www.us.apache.org/dist/maven/maven-3/3.1.1/binaries/apache-maven-3.1.1-bin.tar.gz'
      source_sha1 '630eea2107b0742acb315b214009ba08602dda5f'
      source_url 'http://www.us.apache.org/dist/maven/maven-3/3.2.1/binaries/apache-maven-3.2.1-bin.tar.gz'
      source_sha1 '40e1bf0775fd3ebcac1dbeb61153b871b86b894f'
      source_filetype 'tar.gz'

      def install
        Dir.chdir('apache-maven-3.1.1') do
        FileUtils.rm_rf prefix_path
        execute 'mv', extracted_archive_path + "apache-maven-#{version}", prefix_path
        Dir.chdir(prefix_path) do
          execute 'rm', 'bin/mvn.bat'
          execute 'rm', 'bin/mvnDebug.bat'
        end
      end
    end
  end
end
