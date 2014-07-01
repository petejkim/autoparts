# Copyright (c) 2013-2014 Irrational Industries Inc. d.b.a. Nitrous.IO
# This software is licensed under the [BSD 2-Clause license](https://raw.github.com/nitrous-io/autoparts/master/LICENSE).

require File.join(File.dirname(__FILE__), 'php5')

module Autoparts
  module Packages
    class Php54 < Php5
      name 'php5.4'
      version '5.4.30'
      description 'PHP 5.4: A popular general-purpose scripting language that is especially suited to web development.'
      category Category::PROGRAMMING_LANGUAGES

      source_url 'http://www.php.net/get/php-5.4.30.tar.gz/from/this/mirror'
      source_sha1 '49d4701743cffc91f3c7931170d6896b5da411bf'
      source_filetype 'tar.gz'

      depends_on 'apache2'
      depends_on 'libmcrypt'
    end
  end
end
