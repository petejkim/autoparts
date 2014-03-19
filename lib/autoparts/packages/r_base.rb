module Autoparts
  module Packages
    class RBase < Package
      name 'r_base'
      version '3.0.3'
      description 'R: A free software programming language and software environment for statistical computing and graphics'
      source_url 'http://cran.stat.ucla.edu/src/base/R-3/R-3.0.3.tar.gz'
      source_sha1 '82e83415d27a2fbbdcacb41c4aa14d8b36fdf470'
      source_filetype 'tar.gz'

      def compile
        Dir.chdir('R-' + version) do
         args = [
            "--prefix=#{prefix_path}",
          ]
          prefix_path.mkpath
          execute './configure', *args
          execute 'make'
        end
      end

      def install
        Dir.chdir('R-' + version) do
          execute 'make', 'install'
        end
      end
    end
  end
end
