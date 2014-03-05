# Copyright (c) 2013-2014 Irrational Industries Inc. d.b.a. Nitrous.IO
# This software is licensed under the [BSD 2-Clause license](https://raw.github.com/nitrous-io/autoparts/master/LICENSE).

module Autoparts
  module Packages
    class Tmux < Package
      name 'tmux'
      version '1.9a'
      description 'Tmux: a terminal multiplexer that lets you switch easily between several programs in one terminal.'
      source_url 'http://downloads.sourceforge.net/tmux/tmux-1.9a.tar.gz'
      source_sha1 '815264268e63c6c85fe8784e06a840883fcfc6a2'
      source_filetype 'tar.gz'

      def compile
        Dir.chdir(name_with_version) do
          args = [
            "--prefix=#{prefix_path}",
            "--sysconfdir=#{Path.etc}",
            "--disable-dependency-tracking",
          ]
          execute './configure', *args
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
