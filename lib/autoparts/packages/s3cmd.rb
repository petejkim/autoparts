# Copyright (c) 2013-2014 Irrational Industries Inc. d.b.a. Nitrous.IO
# This software is licensed under the [BSD 2-Clause license](https://raw.github.com/nitrous-io/autoparts/master/LICENSE).

module Autoparts
  module Packages
    class S3cmd < Package
      name 's3cmd'
      version '1.0.1'
      description 's3cmd: Command line tool for managing Amazon S3 and CloudFront services'
      source_url 'https://github.com/s3tools/s3cmd/archive/v1.0.1.zip'
      source_sha1 '4a6f7bfb9300b728ca466967b91aa07521ef6f80'
      source_filetype 'zip'

      def install
        prefix_path.mkpath
        Dir.chdir(extracted_archive_path + name_with_version) do
          execute 'cp', '-r', '.', prefix_path
        end
      end

      def post_install
        bin_path.mkpath
        execute 'ln', '-s', prefix_path + s3cmd_executable, bin_path + s3cmd_executable
      end

      def s3cmd_executable
        's3cmd'
      end
    end
  end
end

