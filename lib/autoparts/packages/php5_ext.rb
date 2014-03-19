# Copyright (c) 2013-2014 Application Craft Ltd. Codio
# This software is licensed under the [BSD 2-Clause license](https://raw.github.com/codio/boxparts/master/LICENSE).

require 'active_support/concern'

module Autoparts
  module Packages
    module Php5Ext
      extend ActiveSupport::Concern

      included do
        self.version '5.5.8'
        self.source_url 'http://us1.php.net/get/php-5.5.8.tar.gz/from/this/mirror'
        self.source_sha1 '19af9180c664c4b8f6c46fc10fbad9f935e07b52'
        self.source_filetype  'tar.gz'
        self.depends_on 'php5'

        def php_extension_dir
          "php-5.5.8/ext/" + php_extension_name
        end


        def php_compile_args
          [ ]
        end

        def compile
          Dir.chdir(php_extension_dir) do
            unless File.exist?('config.m4')
              execute 'cp', 'config0.m4', 'config.m4'
            end

            execute 'phpize'
            execute './configure', *php_compile_args
            execute 'make'
          end
        end

        def config_name
          "#{php_extension_name}.ini"
        end

        def extension_config_path
          get_dependency("php5").php5_ini_path_additional + config_name
        end

        def extension_config
          <<-EOF.unindent
          extension=#{prefix_path}/#{php_extension_name}.so
          EOF
        end

        def install
          prefix_path.mkpath
          Dir.chdir("#{php_extension_dir}/modules") do
            execute 'cp', php_extension_name + '.so', prefix_path
            execute 'cp', php_extension_name + '.la', prefix_path
          end
        end

        def post_install
            File.open(extension_config_path, "w") { |f| f.write extension_config }
        end

        def post_uninstall
          extension_config_path.unlink if extension_config_path.exist?
        end
      end
    end
  end
end
