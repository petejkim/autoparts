module Autoparts
  module Packages
    class Cabal < Package
      name 'cabal'
      version '1.18.0.2'
      description 'Cabal: A system for building and packaging Haskell libraries and programs'
      source_url 'http://www.haskell.org/cabal/release/cabal-install-1.18.0.2/cabal-install-1.18.0.2.tar.gz'
      source_sha1 '2d1f7a48d17b1e02a1e67584a889b2ff4176a773'
      source_filetype 'tar.gz'

      depends_on 'ghc'

      def compile
        Dir.chdir('cabal-install-1.18.0.2') do
          execute "./bootstrap.sh"
          execute "mkdir -p #{bin_path} && cp ~/.cabal/bin/cabal #{bin_path}"
        end
      end
    end
  end
end
