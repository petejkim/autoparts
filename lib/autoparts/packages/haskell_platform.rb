module Autoparts
  module Packages
    class Haskell < Package
      name 'haskell-platform'
      version '2.0.0'
      description 'Haskell is an advanced purely-functional programming language.'
      source_url 'http://www.haskell.org/platform/download/2013.2.0.0/haskell-platform-2013.2.0.0.tar.gz'
      source_sha1 '8669bb5add1826c0523fb130c095fb8bf23a30ce'
      source_filetype 'tar.gz'

      depends_on 'ghc'

      def compile
        Dir.chdir('haskell-platform-2013.2.0.0') do
         args = [
            "--prefix=#{prefix_path}"
          ]

          execute './configure', *args
          execute 'make'
        end
      end

      def install
        Dir.chdir('haskell-platform-2013.2.0.0') do
          execute 'make', 'install'
        end
      end
    end
  end
end
