module Autoparts
  module Packages
    class Ocaml < Package
      name 'ocaml'
      version '4.01.0'
      description 'OCaml: an industrial strength programming language supporting functional, imperative and object-oriented styles'
      source_url 'http://caml.inria.fr/pub/distrib/ocaml-4.01/ocaml-4.01.0.tar.gz'
      source_sha1 '31ae98051d42e038f4fbc5fd338c4fa5c36744e0'
      source_filetype 'tar.gz'
      category Category::PROGRAMMING_LANGUAGES


      def compile
        Dir.chdir(extracted_archive_path + name_with_version) do

          args = [
            "--prefix", "#{prefix_path}",
          ]
          execute './configure', *args

          execute "make -j 1 world bootstrap opt opt.opt"
        end
      end


      def install
        Dir.chdir(extracted_archive_path + name_with_version) do
          system 'make', "PREFIX=#{prefix_path}", 'install'
        end
      end
    end
  end
end