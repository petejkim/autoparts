# Copyright 2014 Romain Lenglet
# This software is licensed under the [BSD 2-Clause license](https://raw.github.com/nitrous-io/autoparts/master/LICENSE).

module Autoparts
  module Packages
    class Parallel < Package
      name 'parallel'
      version '20140722'
      description 'GNU Parallel: A shell tool for executing jobs in parallel using one or more computers'
      category Category::UTILITIES

      source_url 'http://ftp.gnu.org/gnu/parallel/parallel-20140722.tar.bz2'
      source_sha1 '3f92a1069e068cda11cab0e0c698919991e470a0'
      source_filetype 'tar.bz2'

      def compile
        Dir.chdir(name_with_version) do
          args = [
            "--prefix=#{prefix_path}",
            "--disable-documentation"
          ]
          execute './configure', *args
          execute 'make'
        end
      end

      def install
        Dir.chdir(name_with_version) do
          execute 'make', 'install'
        end
      end
    end
  end
end
