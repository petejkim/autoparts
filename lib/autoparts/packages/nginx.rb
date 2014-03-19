module Autoparts
  module Packages
    class Nginx < Package
      name 'nginx'
      version '1.4.4'
      description 'The High Performance Reverse Proxy, Load Balancer, Edge Cache, Origin Server'
      source_url 'http://nginx.org/download/nginx-1.4.4.tar.gz'
      source_sha1 '304d5991ccde398af2002c0da980ae240cea9356'
      source_filetype 'tar.gz'
      category Category::WEB_DEVELOPMENT

      def compile
        Dir.chdir('nginx-1.4.4') do

          args = [
            "--with-pcre",
            "--with-pcre-jit",
            "--user=codio",
            "--group=codio",
            "--prefix=#{prefix_path}",
          ]
          execute './configure', *args
          execute 'make'
        end
      end

      def install
        Dir.chdir('nginx-1.4.4') do
          execute 'make install'
        end
      end

      def purge

      end

      def post_install
        unless nginx_userconfig_dir.exist?
          nginx_userconfig_dir.mkpath
        end
        add_nginx_ctl
        add_nginx_config
      end

      def add_nginx_ctl
         File.open(nginxctl_file, 'w') { |f| f.write nginx_ctl }
         execute 'chmod', '+x', nginxctl_file
      end

      def purge
        if nginx_conf_path.exist?
          FileUtils.rm_r nginx_conf_path
        end
      end

      def add_nginx_config
          File.open(nginx_conf_file, 'w') { |f| f.write nginx_config }

          unless nginx_server_default_file.exist?
            File.open(nginx_server_default_file, 'w') { |f| f.write nginx_server_default }
          end
      end

      def nginx_server_default_file
        nginx_userconfig_dir + 'default.conf'
      end

      def nginx_server_default
        <<-EOS.unindent
          server {
            listen 3000;
            listen 9500;

             location / {
                root #{htdocs_path};
             }
          }
        EOS
      end

      def nginx_config
      <<-EOS.unindent

        worker_processes 1;

        events {
            worker_connections 500;
        }

        http {
            include       #{prefix_path}/conf/mime.types;
            default_type  application/octet-stream;

            sendfile           on;
            keepalive_timeout  65;

            include #{nginx_userconfig_dir}/*.conf;
        }

        EOS
      end

      def nginx_ctl
        <<-EOS.unindent
        #!/bin/sh

        NGINX=#{prefix_path}/sbin/nginx

        find_nginx_pid(){
          echo `ps -ef | grep nginx | grep master | awk '{printf $2;}'`;
        }

        stop_nginx(){
          echo "Killing Nginx process"
          $NGINX -s quit
        }

        restart_nginx(){
          echo "Restarting Nginx process"
          $NGINX -s reload
        }

        start_nginx(){
          echo "Starting Nginx"
          exec $NGINX -c #{nginx_conf_file}
        }

        check_nginx_running(){
          if [ "$(find_nginx_pid)" ]; then
            return 0
          else
            echo "Nginx is not currently running"
            return 1
          fi
        }

        warn_already_running(){
          if [ "$(find_nginx_pid)" ]; then
            echo "Nginx is already running"
            return 0
          else
            return 1
          fi
        }

        show_pid(){
          echo $(find_nginx_pid)
        }

        case $1 in
          start)
            warn_already_running || start_nginx
          ;;
          stop)
            check_nginx_running && stop_nginx
          ;;
          restart)
            check_nginx_running && restart_nginx
          ;;
          pid)
            check_nginx_running && show_pid
          ;;
          status)
            check_nginx_running
          ;;
          *)
            echo "usage : [sudo] nginxctl [pid|start|stop|restart]"
            exit 1
          ;;
        esac

        exit $?
        EOS
      end

      def nginxctl_file
        sbin_path + 'nginxctl'
      end

      def nginx_userconfig_dir
        nginx_conf_path + 'conf.d'
      end

      def nginx_conf_path
        Path.etc + name
      end

      def nginx_conf_file
        nginx_conf_path + 'nginx.conf'
      end

      def start
        execute nginxctl_file.to_s(), "start"
      end

      def stop
        execute nginxctl_file.to_s(), "stop"
      end

      def running?
        !!system( nginxctl_file.to_s(), 'status', out: '/dev/null', err: '/dev/null')
      end

      def tips
        <<-EOS.unindent
          To start the Nginx server:
            $ parts start nginx

          To stop the Nginx server:
            $ parts stop nginx

          Nginx config is located at:
            $ #{nginx_conf_path}

          Nginx custom config is located
            $ #{nginx_userconfig_dir}/*.conf

          Default document root is located at:
            $ #{htdocs_path}

        EOS
      end

      def htdocs_path
        return @htdocs_path if @htdocs_path
        if home_workspace_path.directory?
          home_workspace_htdocs_path.mkpath unless home_workspace_htdocs_path.exist?
          @htdocs_path = home_workspace_htdocs_path
        else
          @htdocs_path = Path.share + name + 'htdocs'
        end
        @htdocs_path
      end

      def home_workspace_path
        Path.home + 'workspace'
      end

      def home_workspace_htdocs_path
        home_workspace_path
      end
    end
  end
end
