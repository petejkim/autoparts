module Autoparts
  module Packages
    class Apache2_2 < Package
      name 'apache2.2'
      version '2.2.25'
      source_url 'http://www.us.apache.org/dist/httpd/httpd-2.2.25.tar.gz'
      source_sha1 '1e793eb477c65dfa58cdf47f7bf78d8cdff58091'
      source_filetype 'tar.gz'

      def compile
        Dir.chdir('httpd-2.2.25') do
          # comment out reference to SSLV2 which OpenSSL doesn't support anymore
          execute "sed -i 's|sc->proxy->protocol != SSL_PROTOCOL_SSLV2 &&|/* sc->proxy->protocol != SSL_PROTOCOL_SSLV2 \&\& */|g' modules/ssl/ssl_engine_io.c"

          File.open('config.layout', 'a') do |f|
            f.write config_layout_file
          end

          args = [
            '--enable-layout=Autoparts',
            "--prefix=#{prefix_path}",
            '--disable-debug',
            '--disable-dependency-tracking',
            '--with-mpm=worker',
            '--with-included-apr',
            '--enable-mods-shared="all ssl cache proxy"',
            '--with-pcre=yes',
            '--with-port=8080'
          ]

          execute './configure', *args
          execute 'make'
        end
      end

      def install
        Dir.chdir('httpd-2.2.25') do
          execute 'make install'
        end
      end

      def post_install
        execute 'mkdir', '-p', Path.var + 'apache2' + 'run'
        execute 'mkdir', '-p', Path.var + 'apache2' + 'log'
      end

      def tips
      end

      def information
        tips
      end

      def config_layout_file
        <<-EOF.unindent
          <Layout Autoparts>
              prefix:        #{prefix_path}
              exec_prefix:   #{prefix_path}
              bindir:        #{bin_path}
              sbindir:       #{bin_path}
              libdir:        #{lib_path}
              libexecdir:    ${exec_prefix}/modules
              mandir:        #{man_path}
              sysconfdir:    #{Path.etc}/apache2
              datadir:       #{share_path}/apache2
              installbuilddir: ${datadir}/build
              errordir:      ${datadir}/error
              iconsdir:      ${datadir}/icons
              htdocsdir:     #{Path.share}/apache2/htdocs
              manualdir:     ${datadir}/manual
              cgidir:        #{Path.share}/apache2/cgi-bin
              includedir:    #{include_path}/apache2
              localstatedir: #{Path.var}/apache2
              runtimedir:    ${localstatedir}/run
              logfiledir:    ${localstatedir}/log
              proxycachedir: ${localstatedir}/proxy
              infodir:       #{info_path}
          </Layout>
        EOF
      end
    end
  end
end
