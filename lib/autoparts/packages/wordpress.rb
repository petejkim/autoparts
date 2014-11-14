# Copyright (c) 2013-2014 Irrational Industries Inc. d.b.a. Nitrous.IO
# This software is licensed under the [BSD 2-Clause license](https://raw.github.com/nitrous-io/autoparts/master/LICENSE).

module Autoparts
  module Packages
    class Wordpress < Package
      name 'wordpress'
      version '4.0'
      description 'WordPress: Web software you can use to create a beautiful website or blog'
      category Category::WEB_DEVELOPMENT

      source_url 'http://wordpress.org/wordpress-4.0.tar.gz'
      source_sha1 '73449bbc015e3d1858f13f56f3289202bd756654'
      source_filetype 'tar.gz'

      depends_on  'php5'
      depends_on  'mysql'

      def install
        Dir.chdir(extracted_archive_path) do
          prefix_path.mkpath
          execute "cp", "wordpress/wp-config-sample.php", prefix_path
          execute "mv", wordpress_folder, htdocs_path
        end
      end

      def post_install
        mysql_dependency.start unless mysql_dependency.running?
        apache2_dependency.start unless apache2_dependency.running?

        Dir.chdir(wordpress_path) do
          success = execute_with_result mysql_dependency.mysql_executable_path, "-u", "root", "-e", "CREATE DATABASE IF NOT EXISTS wordpress"

          if success
            execute "cp", "wp-config-sample.php", "wp-config.php"

            execute "sed", "-i", "s|database_name_here|wordpress|g", "wp-config.php"
            execute "sed", "-i", "s|username_here|root|g", "wp-config.php"
            execute "sed", "-i", "s|password_here||g", "wp-config.php"
          end
        end
      end

      def mysql_dependency
        @mysql_dependency ||= get_dependency 'mysql'
      end

      def apache2_dependency
        unless @apache_dependency
          php_dependency = get_dependency 'php5'
          @apache2_dependency ||= php_dependency.get_dependency 'apache2'
        end

        @apache2_dependency
      end

      def htdocs_path
        @htdocs_path ||= apache2_dependency.htdocs_path
      end

      def wordpress_path
        htdocs_path + wordpress_folder
      end

      def wordpress_folder
        'wordpress'
      end

      def tips
        <<-EOS.unindent
          WordPress has been installed at #{wordpress_path}.

          WordPress requires MySQL and Apache2 to be running (we've started them for you this time):
            parts start mysql
            parts start apache2

          Preview your box on port 3000 and go to /#{wordpress_folder} to setup your WordPress blog.
        EOS
      end
    end
  end
end
