# Copyright (c) 2013-2014 Irrational Industries Inc. d.b.a. Nitrous.IO
# This software is licensed under the [BSD 2-Clause license](https://raw.github.com/nitrous-io/autoparts/master/LICENSE).

module Autoparts
  module Packages
    class SpiderMonkey < Package
      name 'spidermonkey'
      version '1.8.5'

      description "SpiderMonkey: Mozilla's JavaScript engine written in C/C++"

      category Category::LIBRARIES

      source_url 'http://ftp.mozilla.org/pub/mozilla.org/js/js185-1.0.0.tar.gz'

      source_sha1 '52a01449c48d7a117b35f213d3e4263578d846d6'

      source_filetype 'tar.gz'

      def compile
        Dir.chdir('js-1.8.5/js/src') do
          args = [
            "--prefix=#{prefix_path}"
          ]

          execute './configure', *args
          execute 'make'
        end
      end

      def install
        Dir.chdir('js-1.8.5/js/src') do
          execute 'make', 'install'
        end
      end
      
    end
  end
end