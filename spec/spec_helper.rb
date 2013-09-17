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
