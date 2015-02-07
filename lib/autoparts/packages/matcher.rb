# Copyright Chris Schneider <chris@christopher-schneider.com>
# This software is licensed under the [BSD 2-Clause license](https://raw.github.com/nitrous-io/autoparts/master/LICENSE).

module Autoparts
  module Packages
    class Matcher < Package
      name 'matcher'
      version '1.0.0'
      description 'standalone library that does the same fuzzy-find matching as Command-T.vim'
      category Category::UTILITIES
      source_url 'https://codeload.github.com/burke/matcher/tar.gz/1.0.0'
      source_sha1 '84faac0c3d55a7d68557e3448b66a6654da67910'
      source_filetype 'tar.gz'

      def install
        bin_path.mkpath
        `cd #{extracted_archive_path + "matcher-1.0.0"} && make`
        `cp #{extracted_archive_path + "matcher"} #{bin_path}`
      end

      def symlink_all
        symlink_recursively(bin_path, Path.bin, only_executables: true)
      end
    end
  end
end
