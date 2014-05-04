# Copyright (c) 2013-2014 Irrational Industries Inc. d.b.a. Nitrous.IO
# This software is licensed under the [BSD 2-Clause license](https://raw.github.com/nitrous-io/autoparts/master/LICENSE).

module Autoparts
  module Packages
    class Erlang < Package
      name 'erlang'
      version '17.0'
      description 'Erlang/OTP: A programming language used to build massively scalable soft real-time systems with requirements on high availability'
      category Category::PROGRAMMING_LANGUAGES

      source_url 'https://github.com/erlang/otp/archive/OTP-17.0.tar.gz'
      source_sha1 'efa0dd17267ff41d47df94978b7573535c0da775'
      source_filetype 'tar.gz'

      def compile
        Dir.chdir("otp-OTP-#{version}") do
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
        Dir.chdir("otp-OTP-#{version}") do
          bin_path.mkpath
          execute 'make', 'install'
        end
      end
    end
  end
end
