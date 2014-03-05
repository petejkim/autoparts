# Copyright (c) 2013-2014 Irrational Industries Inc. d.b.a. Nitrous.IO
# This software is licensed under the [BSD 2-Clause license](https://raw.github.com/nitrous-io/autoparts/master/LICENSE).

module Autoparts
  module Packages
    class Ant < Package
      name 'ant'
      version '1.9.3'
      description 'Ant: A pure Java build tool, simpler and easier to use than GNU Make'
      source_url 'http://www.us.apache.org/dist//ant/binaries/apache-ant-1.9.3-bin.tar.gz'
      source_sha1 '11a0b936fba02f96b8d737d90c610382232ffea6'
      source_filetype 'tar.gz'

      def install
        prefix_path.parent.mkpath
        FileUtils.rm_rf prefix_path
        execute 'mv', extracted_archive_path + "apache-ant-#{version}", prefix_path
        Dir.chdir prefix_path do
          execute 'rm', '-rf', 'manual', 'INSTALL'
        end
      end
    end
  end
end
