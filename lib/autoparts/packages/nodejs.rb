# Copyright (c) 2013-2014 Irrational Industries Inc. d.b.a. Nitrous.IO
# This software is licensed under the [BSD 2-Clause license](https://raw.github.com/nitrous-io/autoparts/master/LICENSE).

module Autoparts
  module Packages
    class Nodejs < Package
      name 'nodejs'
      version '0.12.0'
      description "Node.JS: A platform built on Chrome's JavaScript runtime for easily building fast, scalable network applications"
      category Category::PROGRAMMING_LANGUAGES

      source_url 'http://nodejs.org/dist/v0.12.0/node-v0.12.0-linux-x64.tar.gz'
      source_sha1 '64fb5260a4a0f914b62a80066d7955856a04703a'
      source_filetype 'tar.gz'

      def install
        prefix_path.parent.mkpath
        FileUtils.rm_rf prefix_path
        execute 'mv', extracted_archive_path + "node-v#{version}-linux-x64", prefix_path
      end
    end
  end
end
