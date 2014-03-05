# Copyright (c) 2013-2014 Irrational Industries Inc. d.b.a. Nitrous.IO
# This software is licensed under the [BSD 2-Clause license](https://raw.github.com/nitrous-io/autoparts/master/LICENSE).

module Autoparts
  module Packages
    class Tig < Package
      name 'tig'
      version '1.2.1'
      description 'Tig: An ncurses-based text-mode interface for git'
      source_url 'http://jonas.nitro.dk/tig/releases/tig-1.2.1.tar.gz'
      source_sha1 '5755bae7342debf94ef33973e0eaff6207e623dc'
      source_filetype 'tar.gz'

      def compile
        Dir.chdir(name_with_version) do
          args = [
            "--prefix=#{prefix_path}",
            "--sysconfdir=#{Path.etc}"
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
