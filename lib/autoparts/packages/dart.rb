module Autoparts
  module Packages
    class Dart < Package
      name 'dart'
      version '1.5.3'

      description 'Dart: new platform for scalable web app engineering'
      category Category::PROGRAMMING_LANGUAGES

      source_url 'http://storage.googleapis.com/dart-archive/channels/stable/release/37972/sdk/dartsdk-linux-x64-release.zip'
      source_sha1 '78e0691b4d5e4a8d3815f3c4e2e0909f7e8cbe86'
      source_filetype 'zip'

      def install
        prefix_path.parent.mkpath
        FileUtils.rm_rf prefix_path
        execute 'mv', extracted_archive_path + "#{name}-sdk", prefix_path
      end
    end
  end
end
