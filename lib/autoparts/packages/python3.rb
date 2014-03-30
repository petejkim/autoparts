# Copyright (c) 2013-2014 Irrational Industries Inc. d.b.a. Nitrous.IO
# This software is licensed under the [BSD 2-Clause license](https://raw.github.com/nitrous-io/autoparts/master/LICENSE).

require File.join(File.dirname(__FILE__), 'python2')

module Autoparts
  module Packages
    class Python3 < Python2
      name 'python3'
      version '3.3.4-1'
      description 'Python 3: Next generation of the most friendly Programming Language'
      source_url 'http://www.python.org/ftp/python/3.3.4/Python-3.3.4.tgz'
      source_sha1 '0561d2a24067c03ed2b29c58a12e126e86ccdc58'
      source_filetype 'tgz'
      category Category::PROGRAMMING_LANGUAGES

      def python_version
        "Python-3.3.4"
      end
      
      def common_version
        "3.3"
      end
    end
  end
end
