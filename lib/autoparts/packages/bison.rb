# Copyright (c) 2013-2014 Irrational Industries Inc. d.b.a. Nitrous.IO
# This software is licensed under the [BSD 2-Clause license](https://raw.github.com/nitrous-io/autoparts/master/LICENSE).

module Autoparts
  module Packages
    class Bison < Package
      name 'bison'
      version '3.0.2'
      description 'Bison: GNU parser generator'
      source_url 'http://ftpmirror.gnu.org/bison/bison-3.0.2.tar.gz'
      source_sha1 '4bbb9a1bdc7e4328eb4e6ef2479b3fe15cc49e54'
      source_filetype 'tar.gz'
      category Category::LIBRARIES

      def compile
        Dir.chdir("bison-3.0.2") do
          args = [
            "--prefix=#{prefix_path}",
            "--disable-dependency-tracking",
          ]
          execute "./configure", *args
          execute "make"
        end
      end

      def install
        Dir.chdir("bison-3.0.2") do
          execute "make", "install"
        end
      end
    end
  end
end
