module Autoparts
  module Packages
    class FreePascal < Package
      name 'freepascal'
      version '2.6.2'
      description 'Free Pascal: OPEN SOURCE COMPILER FOR PASCAL AND OBJECT PASCAL'
      source_url 'http://downloads.sourceforge.net/project/freepascal/Linux/2.6.2/fpc-2.6.2.x86_64-linux.tar'
      source_sha1 'f31c09545b727396f6f2858d12dcebdd25c5c16f'
      source_filetype 'tar'

      def install
        Dir.chdir('fpc-2.6.2.x86_64-linux') do
          prefix_path.mkpath
          File.open('answers.sh', 'w') { |f| f << answers_file }
          execute 'chmod', '+x', 'answers.sh'
          execute './answers.sh | ./install.sh'
        end
      end

      def purge
        execute 'rm', "#{Path.home}/.fpc.cfg"
        execute 'rm', "#{Path.home}/.config/fppkg.cfg"
        execute 'rm', "#{Path.home}/.fppkg/config/default"
      end

      def answers_file
        <<-EOF.unindent
            echo #{prefix_path} # Install Prefix
            echo Y # Textmode IDE
            echo Y # FCL
            echo Y # packages
            echo N # documentation
            echo N # demos
        EOF
      end

      def tips
        <<-EOS.unindent
          To start the ide:
            $ fp

          To use the command line compiler:
            $ fpc
        EOS
      end
    end
  end
end
