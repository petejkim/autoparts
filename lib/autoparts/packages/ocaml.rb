# Copyright (c) 2013-2014 Irrational Industries Inc. d.b.a. Nitrous.IO
# This software is licensed under the [BSD 2-Clause license](https://raw.github.com/nitrous-io/autoparts/master/LICENSE).

module Autoparts
  module Packages
    class Ocaml < Package
      name 'ocaml'
      version '4.01.0'
      description 'OCaml: an industrial strength programming language supporting functional, imperative and object-oriented styles'
      source_url 'http://caml.inria.fr/pub/distrib/ocaml-4.01/ocaml-4.01.0.tar.xz'
      source_sha1 'dc30452c3af957d6b886bc27bca413fd342bd5bc'
      source_filetype 'tar.xz'

      def compile
        Dir.chdir(extracted_archive_path + name_with_version) do
          args = [
            "--prefix", "#{prefix_path}",
          ]
          execute './configure', *args
          execute "make -j 1 world.opt"
        end
      end

      def install
        Dir.chdir(extracted_archive_path + name_with_version) do
          execute 'make', "PREFIX=#{prefix_path}", 'install'
        end
      end
    end
  end
end
