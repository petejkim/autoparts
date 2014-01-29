module Autoparts
  module Packages
    class Ant < Package
      name 'ant'
      version '1.9.3'
      description 'Ant: A pure Java build tool, simpler and easier to use than GNU Make'
      source_url 'http://www.us.apache.org/dist/ant/binaries/apache-ant-1.9.3-bin.tar.gz'
      source_sha1 '11a0b936fba02f96b8d737d90c610382232ffea6'
      source_filetype 'tar.gz'

      def install
        Dir.chdir('apache-ant-1.9.3') do
          prefix_path.mkpath
          execute 'rm', '-rf', 'manual', 'INSTALL'
          execute "mv * #{prefix_path}"
        end
      end
    end
  end
end
