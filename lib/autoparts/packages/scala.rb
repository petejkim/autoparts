# Copyright (c) 2013-2014 Irrational Industries Inc. d.b.a. Nitrous.IO
# This software is licensed under the [BSD 2-Clause license](https://raw.github.com/nitrous-io/autoparts/master/LICENSE).

module Autoparts
  module Packages
    class Scala < Package
      name 'scala'
      version '2.10.3'
      description 'Scala: An object-functional programming language'
      source_url 'http://www.scala-lang.org/files/archive/scala-2.10.3.tgz'
      source_sha1 '04cd6237f164940e1e993a127e7cb21297f3b7ae'
      source_filetype 'tgz'

      def install
        prefix_path.parent.mkpath
        FileUtils.rm_rf prefix_path
        execute 'mv', extracted_archive_path + "scala-#{version}", prefix_path
      end
    end
  end
end
