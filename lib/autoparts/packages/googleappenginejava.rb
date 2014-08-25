# Copyright (c) 2013-2014 Irrational Industries Inc. d.b.a. Nitrous.IO
# This software is licensed under the [BSD 2-Clause license](https://raw.github.com/nitrous-io/autoparts/master/LICENSE).

module Autoparts
  module Packages
    class GoogleAppEngineJava < Package
      name 'googleappenginejava'
      version '1.9.9'
      description 'Google App Engine Java: A CLI for managing Google App Engine cloud services for Java'
      category Category::DEPLOYMENT

      source_url 'https://storage.googleapis.com/appengine-sdks/featured/appengine-java-sdk-1.9.9.zip'
      source_sha1 'df8a3ff44a3cb9e06ecfb1b7ca11f41010b489b0'
      source_filetype 'zip'

      def install
        prefix_path.parent.mkpath
        FileUtils.rm_rf prefix_path
        execute 'mv', extracted_archive_path + "appengine-java-sdk-#{version}", prefix_path
      end

      def post_install
        bin_path.mkpath
        Dir[prefix_path + "*.sh"].each do |p|
          basename = File.basename(p)
          execute 'ln', '-s', prefix_path + basename, bin_path + basename
        end
      end
    end
  end
end
