module Autoparts
  module Packages
    class Dart < Package
      name 'dart'
      version '1.9.1'

      description 'Dart: new platform for scalable web app engineering'
      category Category::PROGRAMMING_LANGUAGES

      source_url 'https://storage.googleapis.com/dart-archive/channels/stable/release/44672/sdk/dartsdk-linux-x64-release.zip'
      source_sha1 '547683feeba68ad8339a2d7c5f8c88847b28d730'
      source_filetype 'zip'

      def install
        prefix_path.parent.mkpath
        FileUtils.rm_rf prefix_path
        execute 'mv', extracted_archive_path + "#{name}-sdk", prefix_path
      end
    end
  end
end
