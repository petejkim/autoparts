module Autoparts
  module Packages
    class InfluxDB < Package
      name 'influxdb'
      version '0.4.4'
      description 'InfluxDB: An open-source distributed time series database'
      source_url 'http://s3.amazonaws.com/influxdb/influxdb-0.4.4.src.tar.gz'
      source_sha1 '04d3b0c6f449daba9470791cc7dd58d88f07db6b'
      source_filetype 'tar.gz'

      depends_on  'protobuf'
      
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
