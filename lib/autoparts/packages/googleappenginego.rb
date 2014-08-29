# Copyright (c) 2013-2014 Irrational Industries Inc. d.b.a. Nitrous.IO
# This software is licensed under the [BSD 2-Clause license](https://raw.github.com/nitrous-io/autoparts/master/LICENSE).

module Autoparts
  module Packages
    class GoogleAppEngineGo < Package
      name 'googleappenginego'
      version '1.9.9'
      description 'Google App Engine for Go: A CLI for managing Google App Engine cloud services for Go'
      category Category::DEPLOYMENT

      source_url 'https://storage.googleapis.com/appengine-sdks/featured/go_appengine_sdk_linux_amd64-1.9.9.zip'
      source_sha1 'ffe770bd81f9fe1e1c3a83e9ebcf2a8c46ed0184'
      source_filetype 'zip'

      def install
        prefix_path.parent.mkpath
        FileUtils.rm_rf prefix_path
        execute 'mv', extracted_archive_path + 'go_appengine', prefix_path
      end

      def post_install
        bin_path.mkpath
        Dir[prefix_path + "*.py"].each do |p|
          basename = File.basename(p)
          execute 'ln', '-fs', prefix_path + basename, bin_path + basename
        end
        ["goapp", "gofmt", "godoc"].each do |p|
          execute 'ln', '-fs', prefix_path + p, bin_path + p
        end
      end
    end
  end
end
