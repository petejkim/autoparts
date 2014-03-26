# Copyright (c) 2013-2014 Irrational Industries Inc. d.b.a. Nitrous.IO
# This software is licensed under the [BSD 2-Clause license](https://raw.github.com/nitrous-io/autoparts/master/LICENSE).

module Autoparts
  module Packages
    class Flex < Package
      name 'flex'
      version '2.5.37'
      description 'Flex: The Fast Lexical Analyzer'
      category Category::DEVELOPMENT_TOOLS

      source_url 'https://downloads.sourceforge.net/flex/flex-2.5.37.tar.bz2'
      source_sha1 'db4b140f2aff34c6197cab919828cc4146aae218'
      source_filetype 'tar.bz2'

      def compile
        Dir.chdir("flex-2.5.37") do
          args = [
            "--prefix=#{prefix_path}",
            "--disable-dependency-tracking",
          ]
          execute "./configure", *args
          execute "make"
        end
      end

      def install
        Dir.chdir("flex-2.5.37") do
          execute "make", "install"
        end
      end
    end
  end
end
