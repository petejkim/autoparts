module Autoparts
  module Packages
    class Fsharp < Package
      name 'fsharp'
      version '3.0'
      description 'F#: a mature, open source, cross-platform, functional-first programming language which empowers users and organizations to tackle complex computing problems with simple, maintainable and robust code.'
      source_url 'https://github.com/fsharp/fsharp/archive/fsharp_30.zip'
      source_sha1 '1266a8b3c48f59d3b5c0ab6d1f3253664e18f213'
      source_filetype 'zip'
      category Category::PROGRAMMING_LANGUAGES

      depends_on 'mono'

      def compile
        Dir.chdir('fsharp-fsharp_30') do
          # hack for mono version check
          execute 'cp', '/bin/true', Path.bin + 'pkg-config'
          args = [
             "--prefix=#{prefix_path}",
             "--with-gacdir=#{get_dependency("mono").lib_path + 'mono' + '4.5'}"
          ]
          execute './autogen.sh', *args
          execute 'make -j 1'
          execute 'rm', Path.bin + 'pkg-config'

        end
      end

      def install
        Dir.chdir('fsharp-fsharp_30') do
          execute 'make install'
        end
      end

    end
  end
end

