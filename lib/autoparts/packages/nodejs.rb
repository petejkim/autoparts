# Copyright (c) 2013-2014 Irrational Industries Inc. d.b.a. Nitrous.IO
# This software is licensed under the [BSD 2-Clause license](https://raw.github.com/nitrous-io/autoparts/master/LICENSE).

module Autoparts
  module Packages
    class Nodejs < Package
      name 'nodejs'
      version '0.10.28'
      description "Node.JS: A platform built on Chrome's JavaScript runtime for easily building fast, scalable network applications"
      category Category::PROGRAMMING_LANGUAGES

      source_url 'http://nodejs.org/dist/v0.10.28/node-v0.10.28-linux-x64.tar.gz'
      source_sha1 '4b9cf9437decea3d9913b694ea2e9b0a06ced2dd'
      source_filetype 'tar.gz'

      def install
        prefix_path.parent.mkpath
        FileUtils.rm_rf prefix_path
        execute 'mv', extracted_archive_path + "node-v#{version}-linux-x64", prefix_path
      end
    end
  end
end
