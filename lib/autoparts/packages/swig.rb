module Autoparts
  module Packages
    class Swig < Package
      name 'swig'
      version '2.0.11'
      description 'Swig: An interface compiler that connects programs written in C and C++ with scripting languages such as Perl, Python, Ruby, and Tcl.'
      source_url 'http://downloads.sourceforge.net/project/swig/swig/swig-2.0.11/swig-2.0.11.tar.gz'
      source_sha1 'd3bf4e78824dba76bfb3269367f1ae0276b49df9'
      source_filetype 'tar.gz'

      def compile
        Dir.chdir(name_with_version) do
          execute './configure', "--prefix=#{prefix_path}", "--disable-dependency-tracking"
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

