# Copyright (c) 2013, Irrational Industries Inc. (Nitrous.IO)
# All rights reserved.

# Redistribution and use in source and binary forms, with or without modification,
# are permitted provided that the following conditions are met:

# 1. Redistributions of source code must retain the above copyright notice, this
#    list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.

# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR
# ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
# ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

module Autoparts
  module Packages
    class PhpMyAdmin < Package
      name 'phpmyadmin'
      version '4.1.7'
      description 'phpMyAdmin: A PHP-based web front-end to MySQL'
      source_url 'http://downloads.sourceforge.net/project/phpmyadmin/phpMyAdmin/4.1.7/phpMyAdmin-4.1.7-all-languages.tar.gz'
      source_sha1 '926c9261e698612e61c725c13262d951bada9cd3'
      source_filetype 'tar.gz'

      depends_on 'php5'
      depends_on 'mysql'
      depends_on 'apache2'

      def install
        Dir.chdir(extracted_archive_path) do
          prefix_path.mkpath
          execute 'cp', '-r', 'phpMyAdmin-4.1.7-all-languages', phpmyadmin_path
          execute 'cp', "phpMyAdmin-4.1.7-all-languages/#{phpmyadmin_sample_config}", prefix_path
        end
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
        Dir.chdir(phpmyadmin_path)do
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
