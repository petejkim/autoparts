# Copyright (c) 2013-2014 Irrational Industries Inc. d.b.a. Nitrous.IO
# This software is licensed under the [BSD 2-Clause license](https://raw.github.com/nitrous-io/autoparts/master/LICENSE).

module Autoparts
  module Packages
    class Opam < Package
      name 'opam'
      version '1.1.1'
      description 'OPAM: a source-based package manager for OCaml.'
      source_url 'https://github.com/ocaml/opam/archive/1.1.1.tar.gz'
      source_sha1 'f1a8291eb888bfae4476ee59984c9a30106cd483'
      source_filetype 'tar.gz'

      depends_on 'ocaml'

      OPAM_ROOT_BASENAME=".opam"

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
          execute 'make install'
        end
      end

      def post_install
        FileUtils.mkdir_p(opam_root)
        execute 'ln', '-s', opam_root, user_opam_root
        execute "#{opam_bin_path} init -y -a"
      end

      def post_uninstall
        user_opam_root.unlink if user_opam_root.symlink?
      end

      def tips
        <<-EOS.unindent
          Add the line

            eval `opam config env`

          to your ~/.bashrc or ~/.zshrc file
        EOS
      end

      def opam_bin_path
        bin_path + 'opam'
      end

      def opam_root
        prefix_path + OPAM_ROOT_BASENAME
      end

      def user_opam_root
        Path.home + OPAM_ROOT_BASENAME
      end
    end
  end
end
