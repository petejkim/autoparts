module Autoparts
  module Packages
    class PhpMyAdmin < Package
      name 'phpmyadmin'
      version '4.1.7'
      description 'phpMyAdmin is a free software tool written in PHP, intended to handle the administration of MySQL over the Web'
      source_url 'http://downloads.sourceforge.net/project/phpmyadmin/phpMyAdmin/4.1.7/phpMyAdmin-4.1.7-all-languages.tar.gz'
      source_sha1 '926c9261e698612e61c725c13262d951bada9cd3'
      source_filetype 'tar.gz'
      category Category::WEB_DEVELOPMENT

      depends_on 'apache2'
      depends_on 'php5-apache2'
      depends_on 'mysql'
      depends_on 'php5-gd'

      def install
          myadmin_path.mkpath
        Dir.chdir('phpMyAdmin-4.1.7-all-languages') do
          execute 'cp', '-r', '.', myadmin_path
        end
      end

      def myadmin_path
        prefix_path + 'phpmyadmin'
      end

      def phpmyadmin_config
        'config.inc.php'
      end

      def phpmyadmin_sample_config
        'config.sample.inc.php'
      end

      def phpmyadmin_apache_config
        <<-EOS.unindent
          # phpMyAdmin default Apache configuration

          Alias /phpmyadmin #{myadmin_path}

          <Directory #{myadmin_path}>
            Order Allow,Deny
            Allow from All
            AllowOverride All
            Require all granted

            Options Indexes FollowSymLinks
            DirectoryIndex index.php

            <IfModule mod_php5.c>
              AddType application/x-httpd-php .php

              php_flag magic_quotes_gpc Off
              php_flag track_vars On
              php_flag register_globals Off
              php_admin_flag allow_url_fopen Off
              php_value include_path .
              php_admin_value upload_tmp_dir #{Path.tmp}
              php_admin_value session.save_path #{Path.tmp}
              php_admin_value open_basedir #{myadmin_path}
            </IfModule>

          </Directory>

          # Disallow web access to directories that don't need it
          <Directory #{myadmin_path}/setup>
              Order Deny,Allow
              Deny from All
          </Directory>
          <Directory #{myadmin_path}/libraries>
              Order Deny,Allow
              Deny from All
          </Directory>
          <Directory #{myadmin_path}/setup/lib>
              Order Deny,Allow
              Deny from All
          </Directory>
        EOS
      end

      def apache_config_name
        name + '.conf'
      end

      def phpmyadmin_apache_config_path
        get_dependency("apache2").apache_custom_config_path + apache_config_name
      end

      def post_install
        Dir.chdir(myadmin_path)do
          FileUtils.cp phpmyadmin_sample_config, phpmyadmin_config
          cookie_rnd = (0...24).map { ('a'..'z').to_a[rand(26)] }.join
          execute 'sed', '-i', "s/a8b7c6d/#{cookie_rnd}/", phpmyadmin_config
        end
        File.open(phpmyadmin_apache_config_path, 'w') { |f| f.write phpmyadmin_apache_config }
      end

      def post_uninstall
        phpmyadmin_apache_config_path.unlink if phpmyadmin_apache_config_path.exist?
      end

      def tips
        <<-EOS.unindent
          Restart apache to activate phpMyAdmin.
            $ parts start apache2

          PhpMyAdmin config file is #{myadmin_path}/{phpmyadmin_config}

          PhpMyAdmin URL is http://your-domain-name:3000/phpmyadmin
        EOS
      end
    end
  end
end
