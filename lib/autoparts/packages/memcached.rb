module Autoparts
  module Packages
    class Memcached < Package
      name 'memcached'
      version '1.4.15'
      description 'Memcached: An open-source, high-performance memory object caching system'
      source_url 'http://memcached.googlecode.com/files/memcached-1.4.15.tar.gz'
      source_sha1 '12ec84011f408846250a462ab9e8e967a2e8cbbc'
      source_filetype 'tar.gz'
      binary_url 'http://nitrousio-autoparts-use1.s3.amazonaws.com/memcached-1.4.15-binary.tar.gz'
      binary_sha1 '3a25110d518e697af0bdc9953b725705e438f8b7'

      def compile
        Dir.chdir('memcached-1.4.15') do
          args = [
            "--prefix=#{prefix_path}",
            "--bindir=#{bin_path}",
            "--sbindir=#{bin_path}",
            "--libexecdir=#{libexec_path}",
            "--datarootdir=#{share_path}/#{name}",
            "--datadir=#{share_path}/#{name}",
            "--sysconfdir=#{Path.etc}",
            "--includedir=#{include_path}",
            "--docdir=#{doc_path}",
            "--libdir=#{lib_path}",
            "--mandir=#{man_path}",
            '--disable-coverage'
          ]

          execute './configure', *args
          execute 'make'
        end
      end

      def install
        Dir.chdir('memcached-1.4.15') do
          bin_path.mkpath
          execute 'make install'
          execute 'cp', 'scripts/memcached-tool', bin_path
          execute 'cp', 'scripts/start-memcached', start_memcached_path

          execute 'sed', '-i', "s|if($> != 0 and $< != 0)|if(0) # if(\$> != 0 and \$< != 0)|g", start_memcached_path
          execute 'sed', '-i', "s|/etc/memcached.conf|#{memcached_conf_path}|g", start_memcached_path
          execute 'sed', '-i', "s|/usr/bin/memcached|#{memcached_path}|g", start_memcached_path
          execute 'sed', '-i', "s|/var/run/memcached.pid|#{memcached_pid_file_path}|g", start_memcached_path
          execute 'sed', '-i', "s|push @$params, \"-u root\"|# push @\$params, \"-u root\"|g", start_memcached_path
          execute 'sed', '-i', "s|exit;|exit(1);|g", start_memcached_path
        end
      end

      def post_install
        memcached_var_path.mkpath
        memcached_log_path.mkpath

        unless memcached_conf_path.exist?
          File.open(memcached_conf_path, 'w') do |f|
            f.write memcached_conf_file
          end
        end
      end

      def memcached_path
        bin_path + 'memcached'
      end

      def start_memcached_path
        bin_path + 'start-memcached'
      end

      def memcached_conf_path
        Path.etc + 'memcached.conf'
      end

      def memcached_var_path
        Path.var + 'memcached'
      end

      def memcached_pid_file_path
        memcached_var_path + 'memcached.pid'
      end

      def memcached_log_path
        Path.var + 'log' + 'memcached'
      end

      def memcached_conf_file
        <<-EOF.unindent
          # Run memcached as a daemon
          -d
          logfile #{memcached_log_path}/memcached.log
          # Start with a cap of 64 megs of memory
          -m 64
          # Default connection port is 11211
          -p 11211
          # Specify which IP address to listen on
          -l 127.0.0.1
          # Limit the number of simultaneous incoming connections
          -c 200
          # Pid file
          -P #{memcached_pid_file_path}
        EOF
      end

      def start
        execute start_memcached_path
      end

      def stop
        if memcached_pid_file_path.exist?
          pid = File.read(memcached_pid_file_path).strip
          if pid.length > 0
            execute 'kill', pid
            memcached_pid_file_path.unlink
          end
        else
          abort "parts: #{name} does not seem to be running."
        end
      end
    end
  end
end
