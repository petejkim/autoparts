module Autoparts
  module Packages
    class Apache2ModWsgi < Package
      name 'apache2_mod_wsgi'
      version '3.4'
      description 'Apache 2 WSGI module: an Apache module that provides a WSGI compliant
interface for hosting Python based web applications within Apache.'
      source_url 'https://modwsgi.googlecode.com/files/mod_wsgi-3.4.tar.gz'
      source_sha1 '92ebc48e60ab658a984f97fd40cb71e0ae895469'
      source_filetype 'tar.gz'
      category Category::WEB_DEVELOPMENT

      depends_on 'apache2'

      def compile
        Dir.chdir('mod_wsgi-3.4') do
          args = [
            "--with-apxs2=#{apache2_dependency.bin_path + "apxs"}",
            # path
            "--prefix=#{prefix_path}",
#            "--with-python",
          ]
          execute './configure', *args
          execute 'make'
        end
      end

      def install
        prefix_path.mkpath
        Dir.chdir('mod_wsgi-3.4') do
          execute 'mv', '.libs/mod_wsgi.so', prefix_path
        end
      end

      def post_install
        unless wsgi_config_path.exist?
          File.open(wsgi_config_path, "w") { |f| f.write wsgi_apache_config }
        end
      end

      def apache2_dependency
        @apache2_dependency ||= get_dependency "apache2"
      end

      def post_uninstall
        wsgi_config_path.unlink if wsgi_config_path.exist?
      end

      def wsgi_config_path
        apache2_dependency.user_config_path + 'wsgi.conf'
      end

      def htdocs_path
        return @htdocs_path if @htdocs_path
        if home_workspace_path.directory?
          home_workspace_htdocs_path.mkpath unless home_workspace_htdocs_path.exist?
          @htdocs_path = home_workspace_htdocs_path
        else
          @htdocs_path = Path.share + name + 'htdocs'
        end
        @htdocs_path
      end

      def wsgi_apache_config
        <<-EOF.unindent
          LoadModule wsgi_module  #{prefix_path}/mod_wsgi.so
          WSGIScriptAlias / #{htdocs_path}
        EOF
      end

      def home_workspace_path
        Path.home + 'workspace'
      end

      def home_workspace_htdocs_path
        home_workspace_path
      end

      def tips
        <<-EOS.unindent
          If Apache2 httpd is already running, you will need to restart it:
            $ parts restart apache2

            Default configuration for wsgi is:
              WSGIScriptAlias / #{htdocs_path}

            You can change default in #{wsgi_config_path} file
        EOS
      end

    end
  end
end