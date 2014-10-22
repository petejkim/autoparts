# Copyright (c) 2013-2014 Irrational Industries Inc. d.b.a. Nitrous.IO
# This software is licensed under the [BSD 2-Clause license](https://raw.github.com/nitrous-io/autoparts/master/LICENSE).

module Autoparts
  module Packages
    class Hub < Package
      name 'hub'
      version '1.12.2'
      description 'hub is a command line tool that wraps git in order to extend it with extra features and commands that make working with GitHub easier.'
      category Category::DEPLOYMENT
      source_url 'https://github.com/github/hub/archive/v1.12.2.tar.gz'
      source_sha1 '65359d3dcc8e1a0986aab3726f6047bfb9df3d7c'
      source_filetype 'tar.gz'

      depends_on 'ruby2.0'

      def install
        bin_path.mkpath
        Dir.chdir(extracted_archive_path + name_with_version) do
          ENV['PREFIX'] = "#{prefix_path}"
          execute "rake", "install"
        end
      end

      def symlink_all
        symlink_recursively(bin_path, Path.bin, only_executables: true)
      end
    end
  end
end
