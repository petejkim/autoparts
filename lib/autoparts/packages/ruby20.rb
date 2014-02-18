module Autoparts
  module Packages
    class Ruby19 < Package
      name 'ruby20'
      version '2.0.0-p353'
      description 'Ruby is a dynamic, open source programming language with a focus on simplicity and productivity.'
      source_url 'https://www.ruby-lang.org/images/header-ruby-logo.png'
      source_sha1 'a678ba3d1f7b2ff28157fc3de9451c4693425d1e'
      source_filetype 'png'

      def install
        execute "/bin/bash -c 'source #{rvm_stable}'"
        execute "/bin/bash -c 'rvm install #{version}'"
      end

      def rvm_stable
        Path.packages + "rvm" + "stable" + "scripts" + "rvm"
      end

    end 
  end
end
