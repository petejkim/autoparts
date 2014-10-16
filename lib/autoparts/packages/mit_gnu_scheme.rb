# Copyright (c) 2013-2014 Irrational Industries Inc. d.b.a. Nitrous.IO
# This software is licensed under the [BSD 2-Clause license](https://raw.github.com/nitrous-io/autoparts/master/LICENSE).

module Autoparts
  module Packages
    class MitGnuScheme < Package
      name 'mit_gnu_scheme'
      version '9.2'
      description "MIT/GNU Scheme: An implementation of the Scheme programming language, providing an interpreter, compiler, source-code debugger, integrated Emacs-like editor, and a large runtime library."
      category Category::PROGRAMMING_LANGUAGES

      source_url 'http://ftp.gnu.org/gnu/mit-scheme/stable.pkg/9.2/mit-scheme-9.2-x86-64.tar.gz'
      source_sha1 'ec1a233a87cf300fe423ddf5d51ce866cef57095'
      source_filetype 'tar.gz'

      def compile
        Dir.chdir(src_path) do
          args = [
            "--prefix=#{prefix_path}"
          ]

          execute './configure', *args
          execute 'make'
        end
      end

      def install
        Dir.chdir(src_path) do
          execute 'make install'
        end
      end

      def tips
        "\nVisit http://www.gnu.org/software/mit-scheme/documentation/mit-scheme-ref/index.html to get started."
      end
      
      private
      
      def src_path
        extracted_archive_path + src_name + 'src'
      end
      
      def src_name
        "mit-scheme-#{version}"
      end
    end
  end
end