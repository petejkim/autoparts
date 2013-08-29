module Autoparts
  module Packages
    class MongoDB < Package
      name 'mongodb'
      version '2.4.6'
      source_url 'http://fastdl.mongodb.org/linux/mongodb-linux-x86_64-2.4.6.tgz'
      source_sha1 '428c67a23d7775d7972fd45509671f8662e014a3'
      source_filetype 'tar.gz'
      binary_url 'http://nitrousio-autoparts-use1.s3.amazonaws.com/mongodb-2.4.6-binary.tar.gz'
      binary_sha1 '5044427b1df22bb297dadcc68ca1bea94f2b5517'

      def compile
        # mongodb is distributed precompiled
      end

      def install
        Dir.chdir('mongodb-linux-x86_64-2.4.6') do
          prefix_path.mkpath
          execute 'cp', '-R', '.', prefix_path
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

      def mongodb_conf_file
        <<-EOF.unindent
          dbpath = #{mongodb_var_path}
          pidfilepath = #{mongodb_var_path}/mongod.pid
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
