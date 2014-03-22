module Autoparts
  module Packages
    class Mono < Package
      name 'mono'
      version '3.2.8'
      description 'Mono: a software platform designed to allow developers to easily create cross platform applications.'
      source_url 'http://download.mono-project.com/sources/mono/mono-3.2.8.tar.bz2'
      source_sha1 'd58403caec82af414507cefa58ce74bbb792985a'
      source_filetype 'tar.bz2'
      category Category::PROGRAMMING_LANGUAGES

      def compile
        Dir.chdir(name_with_version) do
          execute './configure', "--prefix=#{prefix_path}"
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

