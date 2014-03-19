module Autoparts
  module Packages
    class RabbitMQ < Package
      name 'rabbitmq'
      version '3.2.3'
      description 'AMQP server written in Erlang'
      source_url 'https://www.rabbitmq.com/releases/rabbitmq-server/v3.2.3/rabbitmq-server-generic-unix-3.2.3.tar.gz'
      source_sha1 '3a66779c6387499aff1899a4761236bb7ee4e404'
      source_filetype 'tar.gz'
      category Category::DATA_STORES
      depends_on 'erlang'

      def install
        Dir.chdir('rabbitmq_server-3.2.3/') do
          prefix_path.mkpath
          execute 'rm', '-rf', 'INSTALL'
          execute "mv * #{prefix_path}"
        end
      end

      def config_dir
        Path.etc + 'rabbitmq'
      end

      def user_config_dir
        etc_path + 'rabbitmq'
      end

      def post_install
        config_dir.make_symlink(user_config_dir)
      end

      def post_uninstall
        config_dir.unlink if config_dir.symlink?
      end


      def start
        execute sbin_path + "rabbitmq-server", "-detached"
      end

      def stop
        execute sbin_path + "rabbitmqctl", "stop"
      end

      def running?
        !!system((sbin_path + "rabbitmqctl").to_s, "status", out: '/dev/null', err: '/dev/null')
      end

      def tips
        <<-EOS.unindent
          To start the Rabbitmq server:
            $ parts start rabbitmq

          To stop the Rabbitmq server:
            $ parts stop rabbitmq

          Rabbitmq config is located at:
            $ #{rabbitmq_conf_path}
        EOS
      end

      def rabbitmq_conf_path
        Path.etc + 'rabbitmq/'
      end
    end
  end
end
