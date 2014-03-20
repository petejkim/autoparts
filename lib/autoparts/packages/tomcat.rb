module Autoparts
  module Packages
    class Tomcat < Package
      name 'tomcat'
      version '7.0.52'
      description 'Apache Tomcat: an open source software implementation of the Java Servlet and JavaServer Pages technologies.'
      source_url 'http://apache-mirror.rbc.ru/pub/apache/tomcat/tomcat-7/v7.0.52/bin/apache-tomcat-7.0.52.zip'
      source_sha1 'b922ee9691a07d6d75d0c429b6d1789c6c1f86df'
      source_filetype 'zip'
      category Category::WEB_DEVELOPMENT

      def install
        prefix_path.mkpath
        Dir.chdir('apache-tomcat-7.0.52') do
          execute 'cp', '-r', '.', prefix_path.to_s
        end
      end

      def post_install
        Dir.glob(tomcat_bin_path.to_s + '/*.bat').each { |f| File.delete(f) }
        Dir.glob(tomcat_bin_path.to_s + '/*.sh').each { |f| execute 'chmod', '+x', f }
      end

      def tomcat_bin_path
        prefix_path + 'bin'
      end

      def tomcat_conf
        prefix_path + 'conf'
      end

      def tomcat_pid
        Path.tmp + 'catalina.pid'
      end

      def tomcat_env
        {
          "CATALINA_PID" => tomcat_pid.to_s,
        }

      end

      def start
        unless system tomcat_env, (prefix_path + 'bin' + 'startup.sh').to_s
          raise ExecutionFailedError.new 'Fail stop tomcat'
        end
      end

      def stop
        unless system tomcat_env, (prefix_path + 'bin' + 'shutdown.sh').to_s
          raise ExecutionFailedError.new 'Fail to stop tomcat'
        end
      end

      def running?
        pidFile = tomcat_pid
        if File.exists?(pidFile)
          pid = File.read(pidFile).strip
          if pid.length > 0 && `ps -o cmd= #{pid}`.include?('tomcat')
            return true
          end
        end
        false
      end

      def tomcat_config_path
        prefix_path + 'conf'
      end

      def webapps_location
        prefix_path + 'webapps'
      end

      def tips
        <<-EOS.unindent
          To start the Apache Tomcat server:
            $ parts start tomcat

          To stop the Apache Tomcat server:
            $ parts stop tomcat

          Apache Tomcat config is located at:
            $ #{tomcat_config_path}

          Default webapps at:
            $ #{webapps_location}

          Default port: 8080
        EOS
      end
    end
  end
end
