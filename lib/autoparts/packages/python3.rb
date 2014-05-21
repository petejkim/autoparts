# Copyright (c) 2013-2014 Irrational Industries Inc. d.b.a. Nitrous.IO
# This software is licensed under the [BSD 2-Clause license](https://raw.github.com/nitrous-io/autoparts/master/LICENSE).

require File.join(File.dirname(__FILE__), 'python2')

module Autoparts
  module Packages
    class Python3 < Python2
      name 'python3'
      version '3.4.1'
      description 'Python 3: Next generation of the most friendly Programming Language'
      source_url 'https://www.python.org/ftp/python/3.4.1/Python-3.4.1.tgz'
      source_sha1 'e8c1bd575a6ccc2a75f79d9d094a6a29d3802f5d'
      source_filetype 'tgz'
      category Category::PROGRAMMING_LANGUAGES

      def common_version
        "3.4"
      end
    end
  end
end
