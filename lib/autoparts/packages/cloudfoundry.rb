# Copyright (c) 2013-2014 Irrational Industries Inc. d.b.a. Nitrous.IO
# This software is licensed under the [BSD 2-Clause license](https://raw.github.com/nitrous-io/autoparts/master/LICENSE).

module Autoparts
  module Packages
    class Cloudfoundry < Package
      name 'cloudfoundry'
      version '6.0.1'
      description 'Cloud Foundry: An open CLI for managing cloud services'
      category Category::DEPLOYMENT

      source_url 'https://github.com/cloudfoundry/cli/releases/download/v6.0.1/cf-linux-amd64.tgz'
      source_sha1 'e5ab1f9d211f85a1e88e635662be47335313c23b'
      source_filetype 'tgz'

      def install
        bin_path.parent.mkpath
        FileUtils.rm_rf bin_path

        execute 'mv', extracted_archive_path, bin_path
        execute 'chmod', '0755', cf_executable_path
      end

      def cf_executable_path
        bin_path + 'cf'
      end
    end
  end
end

