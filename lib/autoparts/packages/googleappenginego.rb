module Autoparts
  module Packages
    class GoogleAppEngineGo < Package
      name 'googleappenginego'
      version '1.9.4'
      description 'Google App Engine Go: A CLI for managing Google App Engine cloud services for Go'
      category Category::DEPLOYMENT

      source_url 'https://storage.googleapis.com/appengine-sdks/featured/go_appengine_sdk_linux_amd64-1.9.4.zip'
      source_sha1 'ff7c6565d04c99c40fa8fddd0cc8f3ab2e86ba4e'
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
	  execute 'ln', '-s', prefix_path + basename, bin_path + basename
	end
	["goapp", "gofmt", "godoc"].each do |p|
	  execute 'ln', '-s', prefix_path + p, bin_path + p
	end
      end
    end
  end
end
