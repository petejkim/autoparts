module Autoparts
  module Packages
    class Ghc < Package
      name 'ghc'
      version '7.8.2'
      description 'Glasgow Haskell Compiler: a state-of-the-art, open source, compiler and interactive environment for the functional language Haskell.'
      category Category::PROGRAMMING_LANGUAGES

      source_url 'http://www.haskell.org/ghc/dist/7.8.2/ghc-7.8.2-x86_64-unknown-linux-deb7.tar.bz2'
      source_sha1 'e4f88c426db37d6009d0eef406957a62ccb031fa'
      source_filetype 'tar.bz2'

      def compile
        Dir.chdir('ghc-7.8.2') do
	  # Annoying workaround to the fact that the nitrous install doesn't
	  # have libgmp.so, only libgmp.so.10, and the prebuilt ghc wants the
	  # .so version.
          execute "mkdir -p #{lib_path}"
          execute "ln -sf /usr/lib/x86_64-linux-gnu/libgmp.so.10.0.2 #{lib_path}/libgmp.so"

          args = [
            "--prefix=#{prefix_path}"
          ]

          execute "./configure #{args.join(' ')}"
          execute "make install"
        end
      end
    end
  end
end
