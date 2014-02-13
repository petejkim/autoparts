module Autoparts
  module Packages
    class InfluxDB < Package
      name 'influxdb'
      version '0.4.4'
      description 'InfluxDB: An open-source distributed time series database'
      source_url 'http://s3.amazonaws.com/influxdb/influxdb-0.4.4.src.tar.gz'
      source_sha1 '4ba016ed09fa66c80974eea18a4c5036e2c10817'
      source_filetype 'tar.gz'

      def install
        Dir.chdir('influxdb') do
          execute 'make', 'install'
        end
      end

      def compile
        Dir.chdir('influxdb') do
          args = ["--prefix=#{prefix_path}"]
          execute './configure', *args
          execute 'make'
        end
      end
    end
  end
end
