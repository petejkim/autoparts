module Autoparts
  module Packages
    class Dart < Package
      name 'dart'
      version '1.2.0'

      description "Dart: new platform for scalable web app engineering."
      category Category::PROGRAMMING_LANGUAGES 

      source_url 'http://storage.googleapis.com/dart-archive/channels/stable/release/latest/sdk/dartsdk-linux-x64-release.zip'
      source_sha1 '542600aa55653c2ee584d7358b32efee1f25c541'
      source_filetype 'zip'

      def install
        prefix_path.parent.mkpath
        FileUtils.rm_rf prefix_path
        execute 'mv', extracted_archive_path + "#{name}-sdk", prefix_path
      end
    end
  end
end
