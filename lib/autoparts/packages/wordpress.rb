module Autoparts
  module Packages
    class Wordpress < Package
      name 'wordpress'
      version '3.8.1'
      description 'Wordpress: Web software you can use to create a beautiful website or blog'
      source_url 'http://wordpress.org/wordpress-3.8.1.tar.gz'
      source_sha1 '904487e0d70a2d2b6a018aaf99e21608d8f2db88'
      source_filetype 'tar.gz'

      depends_on  'php5'
      depends_on  'mysql'

      def install
        Dir.chdir(extracted_archive_path) do
          prefix_path.mkpath
          execute "mv wordpress #{htdocs_path}"
        end
      end

      def post_install
        mysql_dependency.start unless mysql_dependency.running?

        Dir.chdir(htdocs_path + 'wordpress') do
          execute "mysql", "-u", "root", "-e", "CREATE DATABASE IF NOT EXISTS wordpress"

          execute "cp", "wp-config-sample.php", "wp-config.php"

          execute "sed", "-i", "s|database_name_here|wordpress|g", "wp-config.php"
          execute "sed", "-i", "s|username_here|root|g", "wp-config.php"
          execute "sed", "-i", "s|password_here||g", "wp-config.php"
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
    end
  end
end
