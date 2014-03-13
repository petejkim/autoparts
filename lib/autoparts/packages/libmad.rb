# Copyright (c) 2013-2014 Irrational Industries Inc. d.b.a. Nitrous.IO
# This software is licensed under the [BSD 2-Clause license](https://raw.github.com/nitrous-io/autoparts/master/LICENSE).

module Autoparts
  module Packages
    class Libmad < Package
      name 'libmad'
      version '0.15.1b'
      description 'MPEG audio decoder library'
      category Category::LIBRARIES

      source_url 'ftp://ftp.mars.org/pub/mpeg/libmad-0.15.1b.tar.gz'
      source_sha1 'cac19cd00e1a907f3150cc040ccc077783496d76'
      source_filetype 'tar.gz'

      def compile
        Dir.chdir(name_with_version) do
          args = [
            "--prefix=#{prefix_path}",
            "--bindir=#{bin_path}",
            "--sbindir=#{bin_path}",
            "--sysconfdir=#{Path.etc}",
            "--libdir=#{lib_path}",
            "--includedir=#{include_path}",
            "--datadir=#{share_path}/#{name}",
            "--mandir=#{man_path}",
          ]

          # Generate Makefile
          execute './configure', *args

          # Thats necessary since nitrous.io works with gcc 4.3
          execute "mv Makefile Makefile.bak && sed 's/\-fforce\-mem//g' Makefile.bak > Makefile"

          # Compile it
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
