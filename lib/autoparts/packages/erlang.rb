module Autoparts
  module Packages
    class Erlang < Package
      name 'erlang'
      version 'R16B03-1'
      description 'Erlang OTP: A general-purpose concurrent, garbage-collected programming language and runtime system'
      source_url 'https://github.com/erlang/otp/archive/OTP_R16B03-1.tar.gz'
      source_sha1 'b8f6ff90d9eb766984bb63bf553c3be72674d970'
      source_filetype 'tar.gz'

      def compile
        Dir.chdir("otp-OTP_#{version}") do
          execute "./otp_build autoconf"

          args = [
            "--prefix=#{prefix_path}",
            "--disable-debug",
            "--disable-silent-rules",
            "--enable-kernel-poll",
            "--enable-threads",
            "--enable-dynamic-ssl-lib",
            "--enable-shared-zlib",
            "--enable-smp-support"
          ]

          execute './configure', *args
          execute 'make'
        end
      end

      def install
        Dir.chdir("otp-OTP_#{version}") do
          bin_path.mkpath
          execute 'make', 'install'
        end
      end
    end
  end
end
