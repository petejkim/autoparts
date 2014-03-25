# Copyright (c) 2013-2014 Irrational Industries Inc. d.b.a. Nitrous.IO
# This software is licensed under the [BSD 2-Clause license](https://raw.github.com/nitrous-io/autoparts/master/LICENSE).

module Autoparts
  module Packages
    class Leveldb < Package
      name 'leveldb'
      version '1.15.0'
      description 'Leveldb: A fast and lightweight key/value database library by Google.'
      source_url 'https://leveldb.googlecode.com/files/leveldb-1.15.0.tar.gz'
      source_sha1 '74b70a1156d91807d8d84bfdd026e0bb5acbbf23'
      source_filetype 'tar.gz'
      category Category::DATA_STORES

      depends_on "snappy"

      def compile
        Dir.chdir("leveldb-1.15.0") do
          execute "make"
          execute "make", "leveldbutil"
        end
      end

      def install
        Dir.chdir("leveldb-1.15.0") do
          bin_path.mkpath unless bin_path.exist?
          include_path.mkpath unless include_path.exist?
          lib_path.mkpath unless lib_path.exist?
          execute "cp", "-a", "leveldbutil", bin_path
          execute "cp", "-arf", "include/leveldb", include_path
          execute "cp", "-a", "libleveldb.a", lib_path
          %w(libleveldb.a libleveldb.so libleveldb.so.1 libleveldb.so.1.15).each do |lib|
            execute "cp", "-a", lib, lib_path
          end
        end
      end
    end
  end
end
