# Copyright (c) 2013-2014 Irrational Industries Inc. d.b.a. Nitrous.IO
# This software is licensed under the [BSD 2-Clause license](https://raw.github.com/nitrous-io/autoparts/master/LICENSE).

module Autoparts
  module Packages
    class Ant < Package
      name 'ant'
      version '1.9.2'
      description 'Ant: A pure Java build tool, simpler and easier to use than GNU Make'
      source_url 'http://www.us.apache.org/dist//ant/binaries/apache-ant-1.9.2-bin.tar.gz'
      source_sha1 'fa2c18a27cdf407f5d8306bbc0f0b29513d915d8'
      source_filetype 'tar.gz'

      def install
        Dir.chdir('apache-ant-1.9.2') do
          prefix_path.mkpath
          execute 'rm', '-rf', 'manual', 'INSTALL'
          execute "mv * #{prefix_path}"
        end
      end
    end
  end
end
