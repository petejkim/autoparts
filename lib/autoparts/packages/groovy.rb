module Autoparts
  module Packages
    class Groovy < Package
      name 'groovy'
      version '2.2.2'
      description 'Groovy: an agile and dynamic language for the Java Virtual Machine'
      source_url 'http://dl.bintray.com/groovy/maven/groovy-binary-2.2.2.zip'
      source_sha1 'af74f5e08c089ac6baf4bca99eeb9df209340368'
      source_filetype 'zip'
      category Category::PROGRAMMING_LANGUAGES

      def install
        prefix_path.mkpath
        Dir.chdir(extracted_archive_path + name_with_version) do
          execute 'cp', '-r', '.', prefix_path
        end
        Dir.glob(prefix_path.to_s + '/bin/*.bat').each { |f| File.delete(f) }
      end

    end
  end
end

