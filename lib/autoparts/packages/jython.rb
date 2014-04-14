module Autoparts
  module Packages
    class Jython < Package
      name 'jython'
      version '2.5.3'
      description 'Jython: Python for the Java Platform'
      category Category::PROGRAMMING_LANGUAGES
      
      source_url 'http://search.maven.org/remotecontent?filepath=org/python/jython-installer/2.5.3/jython-installer-2.5.3.jar'
      source_sha1 '6b6ac4354733b6d68d51acf2f3d5c823a10a4ce4'
      source_filetype 'jar'
      
      def install
        prefix_path.parent.mkpath
        FileUtils.rm_rf prefix_path
        execute 'java', '-jar', archive_filename, '-s', '-d', prefix_path
        FileUtils.rm archive_filename
      end
    end
  end
end
