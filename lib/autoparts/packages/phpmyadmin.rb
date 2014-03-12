# Copyright (c) 2013-2014 Irrational Industries Inc. d.b.a. Nitrous.IO
# This software is licensed under the [BSD 2-Clause license](https://raw.github.com/nitrous-io/autoparts/master/LICENSE).

module Autoparts
  module Packages
    class PhpMyAdmin < Package
      name 'phpmyadmin'
      version '4.1.7'
      description 'phpMyAdmin: A PHP-based web front-end to MySQL'
      category Category::WEB_DEVELOPMENT

      source_url 'http://downloads.sourceforge.net/project/phpmyadmin/phpMyAdmin/4.1.7/phpMyAdmin-4.1.7-all-languages.tar.gz'
      source_sha1 '926c9261e698612e61c725c13262d951bada9cd3'
      source_filetype 'tar.gz'

      depends_on 'php5'
      depends_on 'mysql'
      depends_on 'apache2'

      def install
        phpmyadmin_path.parent.mkpath
        FileUtils.rm_rf phpmyadmin_path
        FileUtils.mkdir_p prefix_path
        FileUtils.cp_r extracted_archive_path + 'phpMyAdmin-4.1.7-all-languages/.', extracted_archive_path
        execute 'rm', '-rf', "#{extracted_archive_path}/phpMyAdmin-4.1.7-all-languages"
        execute 'mv', extracted_archive_path, phpmyadmin_path
        execute 'cp', phpmyadmin_path + phpmyadmin_sample_config, prefix_path
      end

      def phpmyadmin_path
        htdocs_path + phpmyadmin_folder
      end

      def phpmyadmin_folder
        'phpmyadmin'
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

          Alias /phpmyadmin #{phpmyadmin_path}

          <Directory #{phpmyadmin_path}>
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
              php_admin_value open_basedir #{phpmyadmin_path}
            </IfModule>

          </Directory>

          # Disallow web access to directories that don't need it
          <Directory #{phpmyadmin_path}/setup>
              Order Deny,Allow
              Deny from All
          </Directory>
          <Directory #{phpmyadmin_path}/libraries>
              Order Deny,Allow
              Deny from All
          </Directory>
          <Directory #{phpmyadmin_path}/setup/lib>
              Order Deny,Allow
              Deny from All
          </Directory>
        EOS
      end

      def apache2_dependency
        get_dependency 'apache2'
      end

      def apache_config_name
        name + '.conf'
      end

      def phpmyadmin_apache_config_path
        get_dependency('apache2').apache_custom_config_path + apache_config_name
      end

      def htdocs_path
        @htdocs_path ||= apache2_dependency.htdocs_path
      end

      def post_install
        Dir.chdir(phpmyadmin_path) do
          FileUtils.cp phpmyadmin_sample_config, phpmyadmin_config
          cookie_rnd = (0...24).map { ('a'..'z').to_a[rand(26)] }.join
          execute 'sed', '-i', "s|a8b7c6d|#{cookie_rnd}|g", phpmyadmin_config
          execute 'sed', '-i', "s|'mysqli'|'mysql'|g", phpmyadmin_config
        end
        File.open(phpmyadmin_apache_config_path, 'w') { |f| f.write phpmyadmin_apache_config }
      end

      def post_uninstall
        phpmyadmin_apache_config_path.unlink if phpmyadmin_apache_config_path.exist?
        phpmyadmin_path.rmtree if phpmyadmin_path.exist?
      end

      def tips
        <<-EOS.unindent
          phpMyAdmin has been installed at #{phpmyadmin_path}.

          phpMyAdmin requires MySQL and Apache2 to be running:
            parts start mysql
            parts start apache2

          phpMyAdmin config file is at #{phpmyadmin_path}/#{phpmyadmin_config}

          If you haven't already done so, set a password for the mysql 'root'
          so that you can login with phpMyAdmin:
            mysqladmin -u root password

          Preview your box on port 3000 and go to /#{phpmyadmin_folder}
          access phpMyAdmin.
        EOS
      end
    end
  end
end
