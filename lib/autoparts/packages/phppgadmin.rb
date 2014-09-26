module Autoparts
  module Packages
    class PhpPgAdmin < Package
      name 'phppgadmin'
      version '5.1'
      description 'phpPgAdmin: a web-based administration tool for PostgreSQL.'
      category Category::WEB_DEVELOPMENT

      source_url 'http://sourceforge.net/projects/phppgadmin/files/phpPgAdmin%20%5Bstable%5D/phpPgAdmin-5.1/phpPgAdmin-5.1.tar.bz2'
      source_sha1 'd7a1f42f79370e1006dcdf558ab888275a70c3c9'
      source_filetype 'tar.gz'

      depends_on 'apache2'
      depends_on 'php5'
      depends_on 'postgresql'

      def install
        phppgadmin_path.parent.mkpath
        FileUtils.rm_rf phppgadmin_path
        FileUtils.mkdir_p prefix_path
        execute 'mv', extracted_archive_path + 'phpPgAdmin-5.1/', phppgadmin_path
        execute 'rm', '-rf', "#{extracted_archive_path}/phpPgAdmin-5.1"
        execute 'mv', extracted_archive_path, phppgadmin_path
      end

      def phppgadmin_path
        htdocs_path + 'phppgadmin'
      end

      def phppgadmin_config
        'config.inc.php'
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

      def apache2_dependency
        get_dependency 'apache2'
      end

      def apache_config_name
        name + '.conf'
      end

      def phppgadmin_apache_config_path
        get_dependency("apache2").apache_custom_config_path + apache_config_name
      end

      def htdocs_path
        @htdocs_path ||= apache2_dependency.htdocs_path
      end

      def post_install
        File.open(phppgadmin_apache_config_path, 'w') { |f| f.write phppgadmin_apache_config }
      end

      def post_uninstall
        phppgadmin_apache_config_path.unlink if phppgadmin_apache_config_path.exist?
        phppgadmin_path.rmtree if phppgadmin_path.exist?
      end

      def tips
        <<-EOS.unindent
          Restart apache to activate phpPgAdmin.

          $ parts start apache2

          PhpPgAdmin config file is #{phppgadmin_path}/#{phppgadmin_config}

          PhpPgAdmin URL is http://your-domain-name/phppgadmin

          The default username is 'action'. You will need to utilize psql to create a password.

          e.g.

          $ psql -U action
          # alter user postgres with password 'YOUR_NEW_PASSWORD';
          # \q

        EOS
      end
    end
  end
end
