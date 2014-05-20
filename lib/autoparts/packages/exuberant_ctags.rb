module Autoparts
  module Packages
    class ExuberantCtags < Package
      name 'exuberant_ctags'
      version '5.8'
      description "Exuberant Ctags: A multilanguage implementation of Ctags"
      category Category::DEVELOPMENT_TOOLS

      source_url 'http://sourceforge.net/projects/ctags/files/ctags/5.8/ctags-5.8.tar.gz/download'
      source_sha1 '482da1ecd182ab39bbdc09f2f02c9fba8cd20030'

      source_filetype 'tar.gz'

      def compile
	Dir.chdir('ctags-5.8') do
	  args = [
	    "--prefix=#{prefix_path}",
	  ]
	  execute './configure', *args
	  execute 'make'
	end
      end

      def install
	Dir.chdir('ctags-5.8') do
	  execute 'make install'
	end
      end

      def tips
	<<-STR.unindent
	  Exuberant Ctags is added in your path. Restart your shell to use it
	STR
      end
    end
  end
end
