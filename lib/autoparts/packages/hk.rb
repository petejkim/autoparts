# Copyright (c) 2013-2014 Irrational Industries Inc. d.b.a. Nitrous.IO
# This software is licensed under the [BSD 2-Clause license](https://raw.github.com/nitrous-io/autoparts/master/LICENSE).

module Autoparts
  module Packages
    class HerokuToolbeltGo < Package
      name 'hk'
      version 'v20140604'
      description 'CLI tool for creating and managing Heroku apps'
      category Category::DEPLOYMENT
      source_url 'https://hk.heroku.com/hk.gz'
      source_filetype 'gz'

      def install
        bin_path.mkpath
        execute 'gunzip', extracted_archive_path + name_with_version
        execute 'mv', extracted_archive_path + name_with_version, hk_executable_path
        execute 'chmod', '+x', hk_executable_path
      end

      def hk_executable_path
        bin_path + 'hk'
      end

      def symlink_all
        symlink_recursively(bin_path, Path.bin, only_executables: true)
      end
    end
  end
end
