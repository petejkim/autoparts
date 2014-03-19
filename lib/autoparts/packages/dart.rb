module Autoparts
  module Packages
    class Dart < Package
      name 'dart'
      version '1.2.0'
      description 'Dart is a new platform for scalable web app engineering'
      source_url 'http://storage.googleapis.com/dart-archive/channels/stable/release/latest/editor/darteditor-linux-x64.zip'
      source_sha1 'fd5a2d249aae8a333ac68c1e0533991279ef6146'
      source_filetype 'zip'
      category Category::PROGRAMMING_LANGUAGES

      def install
        prefix_path.mkpath
        Dir.chdir(extracted_archive_path + 'dart' + 'dart-sdk') do
          execute 'cp', '-r', '.', prefix_path
        end
      end
    end
  end
end

