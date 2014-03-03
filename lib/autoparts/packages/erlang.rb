# Copyright (c) 2013, Irrational Industries Inc. (Nitrous.IO)
# # All rights reserved.
#
# # Redistribution and use in source and binary forms, with or without modification,
# # are permitted provided that the following conditions are met:
#
# # 1. Redistributions of source code must retain the above copyright notice, this
# #    list of conditions and the following disclaimer.
# # 2. Redistributions in binary form must reproduce the above copyright notice,
# #    this list of conditions and the following disclaimer in the documentation
# #    and/or other materials provided with the distribution.
#
# # THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
# # ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# # WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# # DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR
# # ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# # (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# # LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
# # ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# # (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# # SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

module Autoparts
  module Packages
    class Erlang < Package
      name 'erlang'
      version 'R16B03-1'
      description 'Erlang OTP: A programming language used to build massively scalable soft real-time systems with requirements on high availability'
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
