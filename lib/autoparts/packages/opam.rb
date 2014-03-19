module Autoparts
  module Packages
    class Opam < Package
      name 'opam'
      version '1.1.1'
      description 'OPAM: a source-based package manager for OCaml.'
      source_url 'https://github.com/ocaml/opam/archive/1.1.1.tar.gz'
      source_sha1 'f1a8291eb888bfae4476ee59984c9a30106cd483'
      source_filetype 'tar.gz'
      category Category::DEVELOPMENT_TOOLS

      depends_on 'ocaml'

      def compile
        Dir.chdir(extracted_archive_path + name_with_version) do

          args = [
            "--prefix=#{prefix_path}",
          ]
          execute './configure', *args
          execute "make"
        end
      end


      def install
        Dir.chdir(extracted_archive_path + name_with_version) do
          system 'make install'
        end
      end
    end
  end
end