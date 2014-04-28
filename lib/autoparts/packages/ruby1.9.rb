# Copyright (c) 2013-2014 Irrational Industries Inc. d.b.a. Nitrous.IO
# This software is licensed under the [BSD 2-Clause license](https://raw.github.com/nitrous-io/autoparts/master/LICENSE).

require File.join(File.dirname(__FILE__), 'ruby2.1')

module Autoparts
  module Packages
    class Ruby19 < Ruby21
      name 'ruby1.9'
      version '1.9.3-p545'
      description 'Ruby 1.9.3: A dynamic programming language with a focus on simplicity and productivity.'
      source_url 'http://cache.ruby-lang.org/pub/ruby/1.9/ruby-1.9.3-p545.tar.gz'
      source_sha1 '03455364740914e8d2dfd6421f681b3fb68a4313'
      source_filetype 'tar.gz'

      depends_on "chruby"
    end
  end
end
