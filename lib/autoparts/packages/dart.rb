module Autoparts
  module Packages
    class Dart < Package
      name 'dart'
      version '1.3.0'

      description 'Dart: new platform for scalable web app engineering'
      category Category::PROGRAMMING_LANGUAGES

      source_url 'http://storage.googleapis.com/dart-archive/channels/stable/release/34825/sdk/dartsdk-linux-x64-release.zip'
      source_sha1 '17a023802141092b42edb6f4c1db1b909fa79e36'
      source_filetype 'zip'

      def install
        prefix_path.parent.mkpath
        FileUtils.rm_rf prefix_path
        execute 'mv', extracted_archive_path + "#{name}-sdk", prefix_path
      end
    end
  end
end
