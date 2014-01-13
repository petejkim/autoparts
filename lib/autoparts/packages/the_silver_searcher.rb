module Autoparts
  module Packages
    class TheSilverSearcher < Package
      name 'the_silver_searcher'
      version '0.18.1'
      description 'The Silver Searcher: A code-searching tool similar to ack, with focus on speed'
      source_url 'https://github.com/ggreer/the_silver_searcher/archive/0.18.1.tar.gz'
      source_sha1 'efffa28a7e15261dfc027cf94653459a4db0dd92'
      source_filetype 'tar.gz'
      binary_url 'https://nitrousio-autoparts-use1.s3.amazonaws.com/the_silver_searcher-0.18.1-binary.tar.gz'
      binary_sha1 'bfd67a7139004cc049c168ad947e0ae9cdee4ed3'

      def install
        Dir.chdir('the_silver_searcher-0.18.1') do
          execute 'make', 'install'
        end
      end

      def compile
        Dir.chdir('the_silver_searcher-0.18.1') do
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
