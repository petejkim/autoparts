module Autoparts
  module Packages
    class Pip < Package
      name 'pip'
      version '1.5.4'
      description 'Go is an open source programming language that makes it easy to build simple, reliable, and efficient software.'
      source_url 'https://github.com/pypa/pip/archive/master.zip'
      source_sha1 '3f31e1ffd8dc205feaf9e629248a6ef1ecf4c338'
      source_filetype 'zip'

      def install
        Dir.chdir('pip-master/contrib') do
          prefix_path.mkpath
          pip_bin.mkpath
          args = [
            "--root=#{prefix_path}",
#            "--user",
            "--install-option='--install-scripts=#{pip_bin}'",
            "--global-option='--install-scripts=#{pip_bin}'",
          ]
          execute 'python', 'get-pip.py', *args
          execute 'ln', '-s', pip_location + 'bin', prefix_path
          execute 'ln', '-s', pip_location + 'lib', prefix_path
        end
      end

      def pip_bin
        prefix_path + 'pbin'
      end

      def pip_location
        prefix_path + 'usr' + 'local'
      end

      def env_file
        Path.env + 'pip'
      end

      def env_content
        <<-EOS.unindent
          export GOROOT=#{prefix_path}
          export GOPATH=#{go_packages}
        EOS
      end

      def go_packages
        prefix_path + 'gopath'
      end

      def post_install
       # File.write(env_file, env_content)
      end

      def post_uninstall
       # env_file.unlink if env_file.exist?
      end

      def tips
        <<-EOS.unindent

         Close and open terminal to have pip working after the install.

        EOS
      end
    end
  end
end
