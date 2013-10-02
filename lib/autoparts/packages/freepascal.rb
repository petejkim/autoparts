module Autoparts
  module Packages
    class FreePascal < Package
      name 'freepascal'
      version '2.6.2'
      description 'Free Pascal: Open source Pascal compiler for Pascal and Object Pascal' 
      source_url 'https://downloads.sourceforge.net/project/freepascal/Linux/2.6.2/fpc-2.6.2.x86_64-linux.tar'
      source_sha1 'f31c09545b727396f6f2858d12dcebdd25c5c16f'
      source_filetype 'tar'
      binary_url 'https://nitrousio-autoparts-use1.s3.amazonaws.com/freepascal-2.6.2-binary.tar.gz'
      binary_sha1 '1f3eb18f40deb2af7423798acb3fa7c2d55a44ed'

      def install
        Dir.chdir('fpc-2.6.2.x86_64-linux') do
          prefix_path.mkpath
          File.open('answers.sh', 'w') { |f| f << answers_file }
          execute 'chmod', '+x', 'answers.sh'
          # disable samplecfg script
          execute 'sed', '-i', "s|\"\$LIBDIR/samplecfg\"|echo 'skipping samplecfg' # \"\$LIBDIR/samplecfg\"|g", './install.sh'
          execute './answers.sh | ./install.sh'
        end
      end

      def post_install
        # run samplecfg script
        fpc_lib_path = lib_path + 'fpc' + version
        execute (fpc_lib_path + 'samplecfg'), fpc_lib_path
      end

      def purge
        execute 'rm', '-f', "#{Path.home}/.fpc.cfg"
        execute 'rm', '-f', "#{Path.home}/.fpc.bak"
        execute 'rm', '-f', "#{Path.home}/fp.dir"
        execute 'rm', '-f', "#{Path.home}/.config/fppkg.cfg"
        execute 'rm', '-f', "#{Path.home}/.config/fppkg.bak"
        execute 'rm', '-rf', "#{Path.home}/.fppkg"
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
