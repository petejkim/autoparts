module Autoparts
  module Packages
    class TheSilverSearcher < Package
      name 'the_silver_searcher'
      version '0.15'
      description 'A code-searching tool similar to ack, with a focus on speed'
      source_url 'https://github.com/ggreer/the_silver_searcher/archive/0.15.tar.gz'
      source_sha1 '578adf5276a9bf39deb7dbaf86abca96c312a388'
      source_filetype 'tar.gz'
      binary_url 'http://nitrousio-autoparts-use1.s3.amazonaws.com/the_silver_searcher-0.15-binary.tar.gz'
      binary_sha1 'f266c3b935f56778248be0a8e20fd88f4f2a8f2b'

      def install
        Dir.chdir('the_silver_searcher-0.15') do
          execute 'make', 'install'
        end
      end

      def compile
        Dir.chdir('the_silver_searcher-0.15') do
          execute 'aclocal'
          execute 'autoconf'
          execute 'autoheader'
          execute 'automake', '--add-missing'

          args = [
            '--disable-dependency-tracking',
            "--bindir=#{bin_path}",
            "--datarootdir=#{share_path}",
            "--prefix=#{prefix_path}",
            "--mandir=#{man_path}",
            "--docdir=#{doc_path}"
          ]

          execute './configure', *args
          execute 'make'
        end
      end
    end
  end
end
