# Copyright (c) 2013-2014 Irrational Industries Inc. d.b.a. Nitrous.IO
# This software is licensed under the [BSD 2-Clause license](https://raw.github.com/nitrous-io/autoparts/master/LICENSE).

module Autoparts
  module Packages
    class Nodejs < Package
      name 'nodejs'
      version '0.10.26'
      description 'Node.JS: Platform built on Chrome\'s JavaScript runtime for easily building fast, scalable network applications'
      source_url 'http://nodejs.org/dist/v0.10.26/node-v0.10.26-linux-x64.tar.gz'
      source_sha1 'd15d39e119bdcf75c6fc222f51ff0630b2611160'
      source_filetype 'tar.gz'

      def install
        Dir.chdir("node-v#{version}-linux-x64") do
          prefix_path.mkpath
          execute 'cp', '-R', '.', prefix_path
        end
      end
    end
  end
end

