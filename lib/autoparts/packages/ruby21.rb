module Autoparts
  module Packages
    class Ruby21 < Package
      name 'ruby21'
      version '2.1.0'
      description 'Ruby is a dynamic, open source programming language with a focus on simplicity and productivity.'
      source_filetype 'command'

      depends_on 'rvm'

      def install
        prefix_path.mkpath
        execute 'touch', prefix_path + 'INSTALLED_BY_AUTOPARTS' # So that Autoparts thinks the package is installed.
        execute "/bin/bash -c 'source #{rvm_shims} && rvm install #{version} && rvm --default use #{version}'"
        execute "/bin/bash -c 'source $HOME/.bash_profile'"
      end

      def post_uninstall
        execute "/bin/bash -c 'source #{rvm_shims} && rvm uninstall #{version}'"
      end

      def rvm_shims
        Path.packages + "rvm" + "stable" + "scripts" + "rvm"
      end

      def tips
        <<-EOS.unindent
          * To activate the newly installed ruby-#{version} version:
    
            ** On the web IDE, create a new console window.
            ** For terminal based SSH sessions, disconnect and create a new session.
        EOS
      end

    end
  end
end
