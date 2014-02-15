module Autoparts
  module Packages
    class Elasticsearch < Package
      name 'elasticsearch'
      version '1.0.0'
      description 'Elasticsearch: A flexible and powerful open source, distributed, real-time search and analytics engine'
      source_url 'https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.0.0.tar.gz'
      source_sha1 'f190f496502a6608373fca3e8faf65b13dbcc3cd'
      source_filetype 'tar.gz'

      def install
        prefix_path.mkpath
        Dir.chdir(extracted_archive_path + name_with_version) do
          execute 'cp', '-r', '.', prefix_path
        end
      end

      def post_install
        bin_path.mkpath
        es_config_file = prefix_path + 'config' + 'elasticsearch.yml'

        es_data_path.mkpath; es_log_path.mkpath; es_plugins_path.mkpath

        execute 'sed', '-i', "s|# path.data:.*|path.data: #{es_data_path}|g", es_config_file
        execute 'sed', '-i', "s|# path.logs: /path/to/logs|path.logs: #{es_log_path}|g", es_config_file
        execute 'sed', '-i', "s|# path.plugins: /path/to/plugins|path.plugins: #{es_plugins_path}|g", es_config_file
        execute 'sed', '-i', "s|#\\s*network.host:.*|network.host: 127.0.0.1|g", es_config_file
      end

      def start
        execute es_executable, '-d', '-p', es_pid_file_path
      end

      def stop
        pid = read_es_pid_file
        execute 'kill', pid
        # wait until process is killed
        sleep 0.2 while system 'kill', '-0', pid, out: '/dev/null', err: '/dev/null'
        es_pid_file_path.unlink if es_pid_file_path.exist?
      end

      def running?
        if es_pid_file_path.exist?
          pid = read_es_pid_file
          if pid.length > 0 && `ps -o cmd= #{pid}`.include?(es_executable)
            return true
          end
        end
        false
      end

      def es_var_path
        Path.var + 'elasticsearch'
      end

      def es_pid_file_path
        es_var_path + 'es.pid'
      end

      def read_es_pid_file
        @es_pid ||= File.read(es_pid_file_path).strip
      end

      def es_data_path
        es_var_path + 'data'
      end

      def es_log_path
        es_var_path + 'log'
      end

      def es_plugins_path
        es_var_path + 'plugins'
      end

      def es_executable
        'elasticsearch'
      end

      def tips
        <<-EOS.unindent
          To start the server:
            $ parts start elasticsearch

          To stop the server:
            $ parts stop elasticsearch

          Elasticsearch Config is located at:
            $ #{prefix_path + 'config' + 'elasticsearch.yml'}

          Elasticsearch Data is located at:
            $ #{es_data_path}

          Elasticsearch Logs is located at:
            $ #{es_log_path}

          Elasticsearch Plugins is located at:
            $ #{es_plugins_path}
        EOS
      end
    end
  end
end

