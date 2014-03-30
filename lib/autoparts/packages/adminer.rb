module Autoparts
  module Packages
    class Adminer < Package
      name 'adminer'
      version '4.0.3'
      description 'Adminer: a full-featured database management tool written in PHP'
      source_url 'http://downloads.sourceforge.net/adminer/adminer-4.0.3.php'
      source_sha1 '7d30f34ed6f54842305921073bfd0efe7a135c0a'
      source_filetype 'php'
      category Category::WEB_DEVELOPMENT

      depends_on 'apache2'
      depends_on 'php5-apache2'
      depends_on 'php5-gd'
      
      def install
        prefix_path.mkpath
        execute 'mv', archive_filename, adminer_path
      end

      def adminer_path
        prefix_path + 'adminer.php'
      end

      def adminer_apache_config
        <<-EOS.unindent
          # adminer default Apache configuration

          Alias /adminer #{adminer_path}

          <Directory #{prefix_path}>
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
              php_admin_value open_basedir #{adminer_path}
            </IfModule>

          </Directory>
        EOS
      end

      def adminer_config_name
        name + '.conf'
      end

      def adminer_apache_config_path
        get_dependency("apache2").apache_custom_config_path + adminer_config_name
      end

      def post_install
        File.open(adminer_apache_config_path, 'w') { |f| f.write adminer_apache_config }
      end

      def post_uninstall
        adminer_apache_config_path.unlink if adminer_apache_config_path.exist?
      end

      def tips
        <<-EOS.unindent
          Restart apache to activate Adminer.
            $ parts start apache2

          Adminer is  located at #{prefix_path}

          Adminer URL is http://your-domain-name:3000/adminer
        EOS
      end
    end
  end
end
