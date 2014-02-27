# Copyright (c) 2013, Irrational Industries Inc. (Nitrous.IO)
# All rights reserved.

# Redistribution and use in source and binary forms, with or without modification,
# are permitted provided that the following conditions are met:

# 1. Redistributions of source code must retain the above copyright notice, this
#    list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.

# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR
# ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
# ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

module Autoparts
  module Packages
    class GoogleAppEngine < Package
      name 'googleappengine'
      version '1.9.0'
      description 'Google App Engine Python/PHP: A CLI for managing Google App Engine cloud services for Python and PHP'
      source_url 'https://commondatastorage.googleapis.com/appengine-sdks/featured/google_appengine_1.9.0.zip'
      source_sha1 '923a7f99e058d93408d3940e0307bdf2769b7480'
      source_filetype 'zip'

      def install
        prefix_path.mkpath
        Dir.chdir(extracted_archive_path + 'google_appengine') do
          execute 'cp', '-r', '.', prefix_path
        end
      end

      def post_install
        bin_path.mkpath
        Dir[prefix_path + "*.py"].each do |p|
          basename = File.basename(p)
          execute 'ln', '-s', prefix_path + basename, bin_path + basename
        end
      end
    end
  end
end
