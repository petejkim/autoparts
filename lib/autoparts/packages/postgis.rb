# Copyright (c) 2013-2014 Irrational Industries Inc. d.b.a. Nitrous.IO
# This software is licensed under the [BSD 2-Clause license](https://raw.github.com/nitrous-io/autoparts/master/LICENSE).

module Autoparts
  module Packages
    class Postgis < Package
      name 'postgis'
      version '2.1.2'
      description 'PostGIS: Spatial and Geographic objects for PostgreSQL'
      category Category::DATA_STORES
      
      source_url 'http://postgis.net/stuff/postgis-2.1.2dev.tar.gz'
      source_sha1 'dd63cb7baa1870c0d900eb60aa665a9e6509c554'
      source_filetype 'tar.gz'
      
      depends_on 'postgresql'
      depends_on 'geos'
      depends_on 'proj'
      
      def compile
        Dir.chdir('postgis-2.1.2dev') do
          args = [
            "--prefix=#{prefix_path}",
            "--with-projdir=#{Path.packages}/proj/4.8.0",
            "--without-raster"
          ]
      
          execute './configure', *args
          execute 'make'
        end
      end

      def install
        Dir.chdir('postgis-2.1.2dev') do
          execute 'make install'
        end
      end
      
      def purge
        postgis_var_path.rmtree if postgis_var_path.exist?
        postgis_log_path.rmtree if postgis_log_path.exist?
      end
    end
  end
end
