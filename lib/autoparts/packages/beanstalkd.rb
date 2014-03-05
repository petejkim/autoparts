module Autoparts
  module Packages
    class Beanstalkd < Package
      name 'beanstalkd'
      version '1.9'
      description 'Beanstalk: A simple, fast work queue.'
      source_url 'https://github.com/kr/beanstalkd/archive/v1.9.tar.gz'
      source_sha1 'a3cdb93d9c7465491c58c8e7a99d63d779067845'
      source_filetype 'tar.gz'

      def compile
        Dir.chdir('beanstalkd-1.9') do
          execute 'make'
        end
      end

      def install
        Dir.chdir('beanstalkd-1.9') do
          args = [
            "PREFIX=#{prefix_path}"
          ]
          execute 'make', 'install', *args
        end
      end

      def post_install
        beanstalkd_var_path.mkpath
        beanstalkd_log_path.mkpath
      end

      def purge
        beanstalkd_var_path.rmtree if beanstalkd_var_path.exist?
        beanstalkd_log_path.rmtree if beanstalkd_log_path.exist?
      end

      def beanstalkd_path
        bin_path + 'beanstalkd'
      end

      def beanstalkd_var_path
        Path.var + 'beanstalkd'
      end

      def beanstalkd_pid_file_path
        beanstalkd_var_path + 'beanstalkd.pid'
      end

      def beanstalkd_log_path
        Path.var + 'log' + 'beanstalkd'
      end

      def beanstalkd_log_file_path
        beanstalkd_log_path + 'beanstalkd.log'
      end

      def read_beanstalkd_pid_file
        @beanstalkd_pid ||= File.read(beanstalkd_pid_file_path).strip
      end

      def start
        execute "#{beanstalkd_path} > #{beanstalkd_log_file_path} & echo $! > #{beanstalkd_pid_file_path}"
      end

      def stop
        pid = read_beanstalkd_pid_file
        execute 'kill', pid
        # wait until process is killed
        sleep 0.2 while system 'kill', '-0', pid, out: '/dev/null', err: '/dev/null'
        beanstalkd_pid_file_path.unlink if beanstalkd_pid_file_path.exist?
      end

      def running?
        if beanstalkd_pid_file_path.exist?
          pid = read_beanstalkd_pid_file
          if pid.length > 0 && `ps -o cmd= #{pid}`.include?(beanstalkd_path.basename.to_s)
            return true
          end
        end
        false
      end

      def tips
        <<-STR.unindent
          To start the server:
            $ parts start beanstalkd

          To stop the server:
            $ parts stop beanstalkd
        STR
      end
    end
  end
end
