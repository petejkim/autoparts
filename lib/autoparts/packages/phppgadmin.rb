module Autoparts
  module Packages
    class PhpPgAdmin < Package
      name 'phppgadmin'
      version '5.1'
      description 'phpPgAdmin: a web-based administration tool for PostgreSQL.'
      source_url 'http://downloads.sourceforge.net/project/phppgadmin/phpPgAdmin%20%5Bstable%5D/phpPgAdmin-5.1/phpPgAdmin-5.1.tar.gz?r=http%3A%2F%2Fphppgadmin.sourceforge.net%2Fdoku.php%3Fid%3Ddownload&ts=1395472725&use_mirror=heanet'
      source_sha1 'ef90fc9942c67ab95f063cacc43911a40d34fbc1'
      source_filetype 'tar.gz'
      category Category::WEB_DEVELOPMENT

      depends_on 'apache2'
      depends_on 'php5-apache2'
      depends_on 'postgresql'
      depends_on 'php5-gd'

      def install
        phppgadmin_path.mkpath
        Dir.chdir('phpPgAdmin-5.1') do
          execute 'cp', '-r', '.', phppgadmin_path
        end
      end

      def phppgadmin_path
        prefix_path + 'phppgadmin'
      end

      def phpmyadmin_config
        'config.inc.php'
      end

      def phpmyadmin_sample_config
        'config.sample.inc.php'
      end

      def phppgadmin_apache_config
        <<-EOS.unindent
          # phpPgAdmin default Apache configuration

          Alias /phppgadmin #{phppgadmin_path}

          <Directory #{phppgadmin_path}>
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
              php_admin_value open_basedir #{phppgadmin_path}
            </IfModule>

          </Directory>

          # Disallow web access to directories that don't need it
          <Directory #{phppgadmin_path}/setup>
              Order Deny,Allow
              Deny from All
          </Directory>
          <Directory #{phppgadmin_path}/libraries>
              Order Deny,Allow
              Deny from All
          </Directory>
          <Directory #{phppgadmin_path}/setup/lib>
              Order Deny,Allow
              Deny from All
          </Directory>
        EOS
      end

      def apache_config_name
        name + '.conf'
      end

      def phppgadmin_apache_config_path
        get_dependency("apache2").apache_custom_config_path + apache_config_name
      end

      def post_install
        File.open(phppgadmin_apache_config_path, 'w') { |f| f.write phppgadmin_apache_config }
      end

      def post_uninstall
        phppgadmin_apache_config_path.unlink if phppgadmin_apache_config_path.exist?
      end

      def tips
        <<-EOS.unindent
          Restart apache to activate phpMyAdmin.
            $ parts start apache2

          PhpMyAdmin config file is #{phppgadmin_path}/{phpmyadmin_config}

          PhpMyAdmin URL is http://your-domain-name:3000/phppgadmin
        EOS
      end
    end
  end
end
