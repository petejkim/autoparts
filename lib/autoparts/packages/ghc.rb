module Autoparts
  module Packages
    class Ghc < Package
      name 'ghc'
      version '7.6.2'
      description 'GHC is a state-of-the-art, open source, compiler and interactive environment for the functional language Haskell'
      source_url 'http://www.haskell.org/ghc/dist/7.6.3/ghc-7.6.3-x86_64-unknown-linux.tar.bz2'
      source_sha1 '46ec3f3352ff57fba0dcbc8d9c20f7bcb6924b77'
      source_filetype 'tar.gz'

      def compile
        Dir.chdir('ghc-7.6.3') do
         args = [
            "--prefix=#{prefix_path}"
          ]
          execute './configure', *args
        end
      end

      def install
        Dir.chdir('ghc-7.6.3') do
          execute 'make', 'install'
        end
      end
    end
  end
end
