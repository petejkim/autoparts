# Copyright (c) 2013-2014 Irrational Industries Inc. d.b.a. Nitrous.IO
# This software is licensed under the [BSD 2-Clause license](https://raw.github.com/nitrous-io/autoparts/master/LICENSE).

module Autoparts
  module Packages
    class Ack < Package
      name 'ack'
      version '2.12'
      description 'Ack: A tool like grep, optimized for programmers'
      category Category::UTILITIES

      source_url 'http://beyondgrep.com/ack-2.12-single-file'
      source_sha1 '667b5f2dd83143848a5bfa47f7ba848cbe556e93'
      source_filetype 'pl'

      def install
        bin_path.mkpath
        execute 'mv', archive_filename, ack_executable_path
        execute 'chmod', '0755', ack_executable_path
        execute 'ln', '-s', ack_executable_path, (bin_path + 'ack-grep')
      end

      def ack_executable_path
        bin_path + 'ack'
      end
    end
  end
end
