module Autoparts
  module Packages
    class Ruby19 < Package
      name 'ruby19'
      version '1.9.3-p484'
      description 'Ruby is a dynamic, open source programming language with a focus on simplicity and productivity. 1.9'
      source_filetype 'command'

      depends_on 'rvm'

      def install
        prefix_path.mkpath
        execute 'touch', prefix_path + 'INSTALLED_BY_AUTOPARTS' # So that Autoparts thinks the package is installed.
        execute "/bin/bash -c 'source #{rvm_shims} && rvm install #{version} && rvm --default use #{version}'"
      end

      def post_uninstall
        execute "/bin/bash -c 'source #{rvm_shims} && rvm uninstall #{version} && rvm reload'"
      end

      def rvm_shims
        Path.packages + "rvm" + "stable" + "scripts" + "rvm"
      end

    end
  end
end
