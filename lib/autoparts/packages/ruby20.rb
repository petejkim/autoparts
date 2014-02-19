module Autoparts
  module Packages
    class Ruby20 < Package
      name 'ruby20'
      version '2.0.0-p353'
      description 'Ruby is a dynamic, open source programming language with a focus on simplicity and productivity.'

      depends_on 'rvm'

      def install
        prefix_path.mkpath
        execute 'mkdir', prefix_path + name # So that Autoparts thinks the package is installed.
        execute "/bin/bash -c 'source #{rvm_stable}'"
        execute "/bin/bash -c 'rvm install #{version}'"
      end

      def uninstall

      end

      def rvm_stable
        Path.packages + "rvm" + "stable" + "scripts" + "rvm"
      end

    end
  end
end
