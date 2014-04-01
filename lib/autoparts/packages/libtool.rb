module Autoparts
  module Packages
    class Libtool < Package
      name 'libtool'
      version '2.4.2'
      description 'libtool: a generic library support script that hides the complexity of using shared libraries behind a consistent, portable interface.'
      category Category::DEVELOPMENT_TOOLS

      source_url 'http://mirror.anl.gov/pub/gnu/libtool/libtool-2.4.2.tar.gz'
      source_sha1 '22b71a8b5ce3ad86e1094e7285981cae10e6ff88'
      source_filetype 'tar.gz'

      def compile
        Dir.chdir(name_with_version) do
          args = [
            "--prefix=#{prefix_path}",
          ]
          execute './configure', *args
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
