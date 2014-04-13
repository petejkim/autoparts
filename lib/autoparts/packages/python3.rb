# Copyright (c) 2013-2014 Irrational Industries Inc. d.b.a. Nitrous.IO
# This software is licensed under the [BSD 2-Clause license](https://raw.github.com/nitrous-io/autoparts/master/LICENSE).

require File.join(File.dirname(__FILE__), 'python2')

module Autoparts
  module Packages
    class Python3 < Python2
      name 'python3'
      version '3.4.0'
      description 'Python 3: Next generation of the most friendly Programming Language'
      source_url 'http://www.python.org/ftp/python/3.4.0/Python-3.4.0.tgz'
      source_sha1 'bb5125d1c437caa5a62e0a3d0fee298e91196d6f'
      source_filetype 'tgz'
      category Category::PROGRAMMING_LANGUAGES

      def common_version
        "3.4"
      end
    end
  end
end
