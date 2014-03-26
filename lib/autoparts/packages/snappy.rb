# Copyright (c) 2013-2014 Irrational Industries Inc. d.b.a. Nitrous.IO
# This software is licensed under the [BSD 2-Clause license](https://raw.github.com/nitrous-io/autoparts/master/LICENSE).

module Autoparts
  module Packages
    class Snappy < Package
      name 'snappy'
      version '1.1.1'
      description 'Snappy: A fast compressor/decompressor'
      source_url 'https://snappy.googlecode.com/files/snappy-1.1.1.tar.gz'
      source_sha1 '2988f1227622d79c1e520d4317e299b61d042852'
      source_filetype 'tar.gz'
      category Category::LIBRARIES

      def compile
        Dir.chdir("snappy-1.1.1") do
          args = [
            "--prefix=#{prefix_path}",
            "--disable-dependency-tracking",
          ]
          execute "./configure", *args 
          execute "make"
        end
      end

      def install
        Dir.chdir("snappy-1.1.1") do
          execute "make", "install"
        end
      end
    end
  end
end

