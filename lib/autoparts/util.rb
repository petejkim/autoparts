require 'etc'

module Autoparts
  module Util
    class << self
      def sha1(path)
        `shasum -p #{path}`[/^([0-9a-f]*)/, 1]
      end

      def binary_package_compatible?
        `uname -m`.include?('x86_64') && File.exists?('/etc/box')
      end
    end
  end
end
