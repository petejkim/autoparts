# Freebasic autoparts script.
# Written by JD Steffen.
# Oct 2014

module Autoparts
  module Packages
    class FreeBASIC < Package
      name 'freebasic' 
      version '1.00.0'
      description "FreeBASIC is a free/open source (GPL), BASIC compiler for Microsoft Windows, DOS and Linux."
      category Category::PROGRAMMING_LANGUAGES
        
      source_url 'http://sourceforge.net/projects/fbc/files/Binaries%20-%20Linux/FreeBASIC-1.00.0-linux-x86_64.tar.gz/download'
      source_sha1 '0b653f1d100131828c7b6a4c1fe8f39b437f462c'
      source_filetype 'tar.gz'

      def install
       prefix_path.mkpath
          Dir.chdir('FreeBASIC-1.00.0-linux-x86_64') do
            execute "./install.sh -i #{prefix_path}"
          end
      end
    end
  end
end