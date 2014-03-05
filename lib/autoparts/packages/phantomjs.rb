# Copyright (c) 2013-2014 Irrational Industries Inc. d.b.a. Nitrous.IO
# This software is licensed under the [BSD 2-Clause license](https://raw.github.com/nitrous-io/autoparts/master/LICENSE).

module Autoparts
  module Packages
    class PhantomJS < Package
      name 'phantomjs'
      version '1.9.1'
      description 'PhantomJS: A headless WebKit scriptable with a JavaScript API'
      source_url 'https://phantomjs.googlecode.com/files/phantomjs-1.9.1-linux-x86_64.tar.bz2'
      source_sha1 '8ab4753abd352eaed489709c6c7dd13dae67cd91'
      source_filetype 'tar.bz2'

      def install
        prefix_path.parent.mkpath
        FileUtils.rm_rf prefix_path
        execute 'mv', extracted_archive_path + "phantomjs-#{version}-linux-x86_64", prefix_path
      end
    end
  end
end
