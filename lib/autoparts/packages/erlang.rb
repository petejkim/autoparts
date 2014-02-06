module Autoparts
  module Packages
    class Erlang < Package
      name 'erlang'
      version 'R16B03-1'
      description 'Erlang is a programming language used to build massively scalable soft real-time systems with requirements on high availability.'
      source_url 'http://www.erlang.org/download/otp_src_R16B03-1.tar.gz'
      source_sha1 'c2634ea0c078500f1c6a1369f4be59a6d14673e0'
      source_filetype 'tar.gz'

      def compile
        Dir.chdir('otp_src_R16B03-1') do
         args = [
            "--with-cocoa",
            "--prefix=#{prefix_path}",
          ]
          prefix_path.mkpath
          execute './configure', *args
          execute 'make'
        end
      end

      def install
        Dir.chdir('otp_src_R16B03-1') do
          execute 'make', 'install'
        end
      end
    end
  end
end
