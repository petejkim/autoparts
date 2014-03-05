module Autoparts
  module Packages
    class Ghc < Package
      name 'ghc'
      version '7.6.3'
      description 'GHC: a state-of-the-art, open source, compiler and interactive environment for the functional language Haskell.'
      source_url 'http://www.haskell.org/ghc/dist/7.6.3/ghc-7.6.3-x86_64-unknown-linux.tar.bz2'
      source_sha1 '46ec3f3352ff57fba0dcbc8d9c20f7bcb6924b77'
      source_filetype 'tar.bz2'

      def compile
        Dir.chdir('ghc-7.6.3') do
          # Very annoying having to do workarounds for libgmp.  This will be fixed in GHC 7.8 apparently,
          # but this is an artifact of GHC's build system being based on the outdated debian system,
          # which had an older version of libgmp, and had that version number overspecified.
          execute "mkdir -p #{lib_path}"
          execute "ln -sf /usr/lib/x86_64-linux-gnu/libgmp.so.10.0.2 #{lib_path}/libgmp.so.3"
          execute "ln -sf /usr/lib/x86_64-linux-gnu/libgmp.so.10.0.2 #{lib_path}/libgmp.so"

          args = [
            "--prefix=#{prefix_path}"
          ]

          execute "ls -alh > ~/debug.txt"
          execute "LD_LIBRARY_PATH=#{lib_path} ./configure #{args.join(' ')}"
          execute "LD_LIBRARY_PATH=#{lib_path} make install"
        end
      end
    end
  end
end
