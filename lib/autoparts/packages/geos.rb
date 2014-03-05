# Copyright (c) 2013-2014 Irrational Industries Inc. d.b.a. Nitrous.IO
# This software is licensed under the [BSD 2-Clause license](https://raw.github.com/nitrous-io/autoparts/master/LICENSE).

module Autoparts
  module Packages
    class Geos < Package
      name 'geos'
      version '3.4.2'
      description 'GEOS: C++ port of the Java Topology Suite (JTS)'
      source_url 'http://download.osgeo.org/geos/geos-3.4.2.tar.bz2'
      source_sha1 'b8aceab04dd09f4113864f2d12015231bb318e9a'
      source_filetype 'tar.bz2'

      depends_on  'swig'

      def compile
        Dir.chdir(name_with_version) do
          execute './configure', "--prefix=#{prefix_path}", "--disable-dependency-tracking", "--enable-swig"
          execute 'make'
        end
      end

      def install
        Dir.chdir(name_with_version) do
          execute 'make install'
        end
      end
    end
  end
end


