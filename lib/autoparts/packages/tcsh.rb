# Copyright (c) 2013-2014 Irrational Industries Inc. d.b.a. Nitrous.IO
# This software is licensed under the [BSD 2-Clause license](https://raw.github.com/nitrous-io/autoparts/master/LICENSE).

module Autoparts
  module Packages
    class Tcsh < Package
      name 'tcsh'
      version '6.18.01'
      description 'tcsh: TENEX C Shell, an enhanced version of Berkeley csh, usable both as an interactive login shell and a shell script command processor'
      category Category::SHELLS

      source_url 'ftp://ftp.astron.com/pub/tcsh/tcsh-6.18.01.tar.gz'
      source_sha1 'eee2035645737197ff8059c84933a75d23cd76f9'
      source_filetype 'tar.gz'

      def compile
        Dir.chdir(name_with_version) do
          args = %W[
            --prefix=#{prefix_path}
            --sysconfdir=#{Path.etc}
            --disable-dependency-tracking
          ]
          execute './configure', *args
          execute 'make'
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
