# Copyright (c) 2013-2014 Irrational Industries Inc. d.b.a. Nitrous.IO
# This software is licensed under the [BSD 2-Clause license](https://raw.github.com/nitrous-io/autoparts/master/LICENSE).

module Autoparts
  module Packages
    class Proj < Package
      name 'proj'
      version '4.8.0'
      description 'Proj.4: PROJ.4 Cartographic Projections library'
      category Category::LIBRARIES

      source_url 'http://download.osgeo.org/proj/proj-4.8.0.tar.gz'
      source_sha1 '5c8d6769a791c390c873fef92134bf20bb20e82a'
      source_filetype 'tar.gz'

      def compile
        Dir.chdir(name_with_version) do
          execute './configure', "--prefix=#{prefix_path}"
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
