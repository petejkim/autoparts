# Copyright (c) 2013-2014 Irrational Industries Inc. d.b.a. Nitrous.IO
# This software is licensed under the [BSD 2-Clause license](https://raw.github.com/nitrous-io/autoparts/master/LICENSE).

module Autoparts
  module Packages
    class PhantomJS < Package
      name 'phantomjs'
      version '1.9.8'
      description 'PhantomJS: A headless WebKit scriptable with a JavaScript API'
      category Category::WEB_DEVELOPMENT

      source_url 'https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-1.9.8-linux-x86_64.tar.bz2'
      source_sha1 'd29487b2701bcbe3c0a52bc176247ceda4d09d2d'
      source_filetype 'tar.bz2'

      def install
        prefix_path.parent.mkpath
        FileUtils.rm_rf prefix_path
        execute 'mv', extracted_archive_path + "phantomjs-#{version}-linux-x86_64", prefix_path
      end
    end
  end
end
