# Copyright (c) 2013-2014 Irrational Industries Inc. d.b.a. Nitrous.IO
# This software is licensed under the [BSD 2-Clause license](https://raw.github.com/nitrous-io/autoparts/master/LICENSE).

module Autoparts
  module Packages
    class Vim < Package
      name 'vim'
      version '7.4.335'
      description 'Vim: A highly configurable text editor'
      category Category::UTILITIES

      source_url 'http://ftp.debian.org/debian/pool/main/v/vim/vim_7.4.335.orig.tar.gz'
      source_sha1 '0a548b3463b362e2f7fdc493158dd42aa48ab760'
      source_filetype 'tgz'

      def compile
        Dir.chdir(name_with_version) do
          args = [
            "--prefix=#{prefix_path}",
            '--with-compiledby=Nitrous.IO',
            '--enable-multibyte',
            '--with-features=huge',
            '--enable-cscope',
            '--enable-gui=no',
            '--without-x',
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

      def post_install
        File.open("#{share_path}/vim/vimrc", 'w') do |f|
          f.write default_vimrc
        end
      end

      private
      # A default vimrc is needed mainly to set nocompatible mode. This is only
      # used when there are no other vimrc files available.
      def default_vimrc
        <<-EOS.unindent
          set nocompatible
          syntax on
        EOS
      end
    end
  end
end
