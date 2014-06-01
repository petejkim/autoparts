module Autoparts
  module Packages
    class GoogleAppEngineJava < Package
      name 'googleappenginejava'
      version '1.9.5'
      description 'Google App Engine Java: A CLI for managing Google App Engine cloud services for Java'
      category Category::DEPLOYMENT

      source_url 'https://storage.googleapis.com/appengine-sdks/featured/appengine-java-sdk-1.9.5.zip'
      source_sha1 'b662c48b932c7c10fa634c25e64adc62f7c66ddf'
      source_filetype 'zip'

      def install
        prefix_path.parent.mkpath
        FileUtils.rm_rf prefix_path
        execute 'mv', extracted_archive_path + 'appengine-java-sdk-1.9.5', prefix_path
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
