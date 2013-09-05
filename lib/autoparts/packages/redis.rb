module Autoparts
  module Packages
    class Redis < Package
      name 'redis'
      version '2.6.16'
      description 'Redis: An open-source, in-memory, key-value data store'
      source_url 'http://download.redis.io/releases/redis-2.6.16.tar.gz'
      source_sha1 'f94c0f623aaa8c310f9be2a88e81716de01ce0ce'
      source_filetype 'tar.gz'
      binary_url 'http://nitrousio-autoparts-use1.s3.amazonaws.com/redis-2.6.16-binary.tar.gz'
      binary_sha1 '8e56a18baf076955dac87b8c6b6b2d57155c0c2e'

      def compile
        Dir.chdir('redis-2.6.16') do
          execute 'make'
        end
      end

      def install
        Dir.chdir('redis-2.6.16') do
          prefix_path.mkpath
          bin_path.mkpath
          %w(redis-benchmark redis-check-aof redis-check-dump redis-cli redis-sentinel redis-server).each do |f|
            execute 'cp', "src/#{f}", bin_path
          end

          execute 'cp', '00-RELEASENOTES', prefix_path
          execute 'cp', 'COPYING', prefix_path
          execute 'cp', 'README', prefix_path

          execute 'cp', 'sentinel.conf', (prefix_path + 'sentinel.example.conf')
          execute 'cp', 'redis.conf', redis_example_conf_path

          execute 'sed', '-i', "s|daemonize no|daemonize yes|g", redis_example_conf_path
          execute 'sed', '-i', "s|pidfile /var/run/redis.pid|pidfile #{redis_pid_file_path}|g", redis_example_conf_path
          execute 'sed', '-i', "s|logfile stdout|logfile #{redis_log_path + 'redis.log'}|g", redis_example_conf_path
          execute 'sed', '-i', "s|dir \./|dir #{redis_var_path}|g", redis_example_conf_path
          execute 'sed', '-i', "s|# bind 127.0.0.1|bind 127.0.0.1|g", redis_example_conf_path
        end
      end

      def post_install
        redis_var_path.mkpath
        redis_log_path.mkpath

        unless redis_conf_path.exist?
          execute 'cp', redis_example_conf_path, redis_conf_path
        end
      end

      def redis_server_path
        bin_path + 'redis-server'
      end

      def redis_example_conf_path
        prefix_path + 'redis.example.conf'
      end

      def redis_conf_path
        Path.etc + 'redis.conf'
      end

      def redis_var_path
        Path.var + 'redis'
      end

      def redis_pid_file_path
        redis_var_path + 'redis.pid'
      end

      def redis_log_path
        Path.var + 'log' + 'redis'
      end

      def start
        # redis-cli returns 0 even if AUTH 0 command fails as long as connection is made
        if system "#{bin_path}/redis-cli", 'AUTH', '0', out: '/dev/null', err: '/dev/null'
          raise StartFailedError.new "#{name} is already running."
        end
        execute redis_server_path, redis_conf_path
      end

      def stop
        if redis_pid_file_path.exist?
          pid = File.read(redis_pid_file_path).strip
          # check if pid actually belongs to redis process
          if pid.length > 0 && `ps -o cmd= #{pid}`.include?(redis_server_path.basename.to_s)
            execute 'kill', pid
            # wait until process is killed
            sleep 0.2 while system 'kill', '-0', pid, out: '/dev/null', err: '/dev/null'
            # redis should remove pid file on its own, but delete if it still exists
            redis_pid_file_path.unlink if redis_pid_file_path.exist?
            return
          end
          # pid belongs to some other process. just delete pid file.
          redis_pid_file_path.unlink
        end
        raise StopFailedError.new "#{name} does not seem to be running."
      end

      def status
      end

      def tips
        <<-EOS.unindent
          To start the server:
            $ parts start redis

          To stop the server:
            $ parts stop redis

          To connect to the server:
            $ redis-cli
        EOS
      end
    end
  end
end
