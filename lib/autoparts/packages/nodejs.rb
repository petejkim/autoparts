# Copyright (c) 2013-2014 Irrational Industries Inc. d.b.a. Nitrous.IO
# This software is licensed under the [BSD 2-Clause license](https://raw.github.com/nitrous-io/autoparts/master/LICENSE).

module Autoparts
  module Packages
    class Nodejs < Package
      name 'nodejs'
      version '0.10.35'
      description "Node.JS: A platform built on Chrome's JavaScript runtime for easily building fast, scalable network applications"
      category Category::PROGRAMMING_LANGUAGES

      source_url 'http://nodejs.org/dist/v0.10.35/node-v0.10.35-linux-x64.tar.gz'
      source_sha1 '3a202a749492e48542d2c28220e43ef6dae084bc'
      source_filetype 'tar.gz'

      def install
        prefix_path.parent.mkpath
        FileUtils.rm_rf prefix_path
        execute 'mv', extracted_archive_path + "node-v#{version}-linux-x64", prefix_path
      end
    end
  end
end
