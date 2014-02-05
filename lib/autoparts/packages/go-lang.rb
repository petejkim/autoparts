module Autoparts
  module Packages
    class Go < Package
      name 'go-lang'
      version '1.2'
      description 'Go is an open source programming language that makes it easy to build simple, reliable, and efficient software.'
      source_url 'https://go.googlecode.com/files/go1.2.linux-amd64.tar.gz'
      source_sha1 '664e5025eae91412a96a10f4ed1a8af6f0f32b7d'
      source_filetype 'tar.gz'

      def install
        Dir.chdir('go') do
          prefix_path.mkpath
          execute 'rm', '-rf', 'manual', 'INSTALL'
          execute "mv * #{prefix_path}"
        end
      end

      def env_file
        Path.env + 'go-lang'
      end

      def env_content
        <<-EOS.unindent
          export GOROOT=~/.parts/packages/go-lang/1.2/
        EOS
      end

      def post_install
        File.write(env_file, env_content)
      end

      def post_uninstall
        env_file.unlink if env_file.exist?
      end

      def tips
        <<-EOS.unindent

         Close and open terminal to have go-lang working after the install.

        EOS
      end
    end
  end
end
