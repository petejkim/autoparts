# Copyright (c) 2013-2014 Irrational Industries Inc. d.b.a. Nitrous.IO
# This software is licensed under the [BSD 2-Clause license](https://raw.github.com/nitrous-io/autoparts/master/LICENSE).

module Autoparts
  module Packages
    class MongoDB < Package
      name 'mongodb'
      version '2.6.5'
      description 'MongoDB: A cross-platform document-oriented NoSQL database system'
      category Category::DATA_STORES

      source_url 'http://fastdl.mongodb.org/linux/mongodb-linux-x86_64-2.6.5.tgz'
      source_sha1 'd8d793fdd23b784e6d40c3e8e923926ac004a96d'
      source_filetype 'tar.gz'

      def compile
        # mongodb is distributed precompiled
      end

      def install
        prefix_path.parent.mkpath
        FileUtils.rm_rf prefix_path
        execute 'mv', extracted_archive_path + "mongodb-linux-x86_64-#{version}", prefix_path
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
