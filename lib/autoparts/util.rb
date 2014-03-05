# Copyright (c) 2013-2014 Irrational Industries Inc. d.b.a. Nitrous.IO
# This software is licensed under the [BSD 2-Clause license](https://raw.github.com/nitrous-io/autoparts/master/LICENSE).

require 'etc'

module Autoparts
  module Util
    class << self
      def sha1(path)
        `shasum -p #{path}`[/^([0-9a-f]*)/, 1]
      end

      def binary_package_compatible?
        `uname -m`.include?('x86_64') && Etc.getlogin == 'action' && Path.root.to_s == '/home/action/.parts'
      end
    end
  end
end
