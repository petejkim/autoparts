# Copyright Chris Schneider <chris@christopher-schneider.com>
# This software is licensed under the [BSD 2-Clause license](https://raw.github.com/nitrous-io/autoparts/master/LICENSE).

module Autoparts
  module Packages
    class Purescript < Package
      name 'purescript'
      version '0.5.7.1'
      description 'PureScript is a small strongly, statically typed programming language with expressive types, written in and inspired by Haskell, and compiling to Javascript'
      category Category::PROGRAMMING_LANGUAGES
      source_url 'https://github.com/purescript/purescript/releases/download/v0.5.7.1/linux64.tar.gz'
      source_sha1 '35bdb1665818ca372ada68ee8b97b58580d88859'
      source_filetype 'tar.gz'

      def install
        bin_path.mkpath
        prelude_path = ENV["HOME"] + "/.purescript/prelude"

        `cp #{extracted_archive_path + "purescript"}/docgen       #{bin_path}`
        `cp #{extracted_archive_path + "purescript"}/psc          #{bin_path}`
        `cp #{extracted_archive_path + "purescript"}/psc-make     #{bin_path}`
        `cp #{extracted_archive_path + "purescript"}/psci         #{bin_path}`

        # Prelude must be in a known spot. This will change in future purescript releases
        `mkdir -p #{prelude_path}`
        `cp #{extracted_archive_path + "purescript"}/prelude.purs #{prelude_path}/prelude.purs`
      end

      def symlink_all
        symlink_recursively(bin_path, Path.bin, only_executables: true)
      end
    end
  end
end
