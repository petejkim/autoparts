module Autoparts
  module Packages
    class MongoDB < Package
      name 'mongodb'
      version '2.4.6'
      description 'MongoDB: A cross-platform document-oriented NoSQL database system'
      source_url 'http://fastdl.mongodb.org/linux/mongodb-linux-x86_64-2.4.6.tgz'
      source_sha1 '428c67a23d7775d7972fd45509671f8662e014a3'
      source_filetype 'tar.gz'
      binary_url 'https://nitrousio-autoparts-use1.s3.amazonaws.com/mongodb-2.4.6-binary.tar.gz'
      binary_sha1 '5044427b1df22bb297dadcc68ca1bea94f2b5517'

      def compile
        # mongodb is distributed precompiled
      end

      def install
        Dir.chdir('mongodb-linux-x86_64-2.4.6') do
          prefix_path.mkpath
          execute "mv * #{prefix_path}"
        end
      end

      def post_install
        mongodb_var_path.mkpath
        mongodb_log_path.mkpath

        unless mongodb_conf_path.exist?
          File.open(mongodb_conf_path, 'w') do |f|
            f.write mongodb_conf_file
          end
        end
      end

      def purge
        mongodb_var_path.rmtree if mongodb_var_path.exist?
        mongodb_log_path.rmtree if mongodb_log_path.exist?
        mongodb_conf_path.unlink if mongodb_conf_path.exist?
      end

      def mongod_path
        bin_path + 'mongod'
      end

      def mongodb_conf_path
        Path.etc + 'mongodb.conf'
      end

      def mongodb_var_path
        Path.var + 'mongodb'
      end

      def mongodb_log_path
        Path.var + 'log' + 'mongodb'
      end

      def mongod_pid_file_path
        mongodb_var_path + 'mongod.pid'
      end

      def mongodb_conf_file
        <<-EOF.unindent
          # Changing the following settings may break Autoparts process management
          dbpath = #{mongodb_var_path}
          pidfilepath = #{mongod_pid_file_path}
          logpath = #{mongodb_log_path}/mongod.log
          logappend = true
          bind_ip = 127.0.0.1
          smallfiles = true
        EOF
      end

      def start
        execute mongod_path, '--fork', '--config', mongodb_conf_path
      end

      def stop
        execute mongod_path, '--shutdown', '--config', mongodb_conf_path
        mongod_pid_file_path.unlink if mongod_pid_file_path.exist?
      end

      def running?
        if mongod_pid_file_path.exist?
          pid = File.read(mongod_pid_file_path).strip
          if pid.length > 0 && `ps -o cmd= #{pid}`.include?(mongod_path.basename.to_s)
            return true
          end
        end
        false
      end

      def tips
        <<-EOS.unindent
          To start the server:
            $ parts start mongodb

          To stop the server:
            $ parts stop mongodb

          To open MongoDB shell:
            $ mongo
        EOS
      end
    end
  end
end
