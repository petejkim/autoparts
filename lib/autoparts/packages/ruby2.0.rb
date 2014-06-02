# Copyright (c) 2013-2014 Irrational Industries Inc. d.b.a. Nitrous.IO
# This software is licensed under the [BSD 2-Clause license](https://raw.github.com/nitrous-io/autoparts/master/LICENSE).

require File.join(File.dirname(__FILE__), 'ruby2.1')

module Autoparts
  module Packages
    class Ruby20 < Ruby21
      name 'ruby2.0'
      version '2.0.0-p451'
      description 'Ruby 2.0.0: A dynamic programming language with a focus on simplicity and productivity.'
      category Category::PROGRAMMING_LANGUAGES

      source_url 'http://cache.ruby-lang.org/pub/ruby/2.0/ruby-2.0.0-p451.tar.gz'
      source_sha1 '258adeba517c04f2c972736dece6c27ecea03432'
      source_filetype 'tar.gz'

      depends_on "chruby"
    end
  end
end
