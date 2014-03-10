# Copyright (c) 2013-2014 Irrational Industries Inc. d.b.a. Nitrous.IO
# This software is licensed under the [BSD 2-Clause license](https://raw.github.com/nitrous-io/autoparts/master/LICENSE).

require 'fakefs/safe'
require 'timecop'

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift File.expand_path('../../vendor', __FILE__)
require 'autoparts'

RSpec.configure do |config|
  config.before :each do
    FakeFS::FileSystem.clear
    FakeFS.activate!
  end

  config.after :each do
    FakeFS.deactivate!
  end
end

module FakeFS
  class FileTest
    def self.executable?(file_name)
      File.executable?(file_name)
    end

    def self.symlink?(file_name)
      File.symlink?(file_name)
    end
  end

  class File
    def self.executable?(filename)
      (FileSystem.find(filename).mode - 0100000) & 0100 != 0
    end

    def self.realpath(pathname, dir_string=null)
      path = dir_string ? dir_string + pathname : pathname
      readlink(path)
    end
  end
end
