# Copyright (c) 2013-2014 Irrational Industries Inc. d.b.a. Nitrous.IO
# This software is licensed under the [BSD 2-Clause license](https://raw.github.com/nitrous-io/autoparts/master/LICENSE).

#preinstalled
=begin
module Autoparts
  module Packages
    class Zsh < Package
      name 'zsh'
      version '5.0.5'
      description 'Zsh: A shell with lots of features'
      category Category::SHELLS

      source_url 'https://downloads.sourceforge.net/project/zsh/zsh/5.0.5/zsh-5.0.5.tar.bz2'
      source_sha1 '75426146bce45ee176d9d50b32f1ced78418ae16'
      source_filetype 'tar.gz'

      def compile
        Dir.chdir(name_with_version) do
          args = %W[
            --prefix=#{prefix_path}
            --sysconfdir=#{Path.etc}
            --enable-fndir=#{Path.share}/zsh/functions
            --enable-scriptdir=#{Path.share}/zsh/scripts
            --enable-cap
            --enable-multibyte
            --enable-pcre
            --enable-zsh-secure-free
            --with-tcsetpgrp
          ]
          execute './configure', *args
        end
      end

      def install
        Dir.chdir(name_with_version) do
          bin_path.mkpath
          execute 'make install'
        end
      end
    end
  end
end
=end