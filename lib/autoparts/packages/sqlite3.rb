module Autoparts
  module Packages
    class Sqlite3 < Package
      name 'sqlite3'
      version '3.8.2'
      description 'SQLite is an in-process library that implements a self-contained, serverless, zero-configuration, transactional SQL database engine.'
      source_url 'http://www.sqlite.org/2013/sqlite-autoconf-3080200.tar.gz'
      source_sha1 '6033ef603ce221d367c665477514d972ef1dc90e'
      source_filetype 'tar.gz'
      category Category::DATA_STORES

      def compile
        Dir.chdir('sqlite-autoconf-3080200') do
          file = File.readlines('sqlite3.c')
          file.insert(0, "#define SQLITE_ENABLE_COLUMN_METADATA")
          File.open('sqlite3.c', 'w') do |f|
            file.each { |element| f.puts(element) }
          end
          args = [
            "--prefix=#{prefix_path}"
          ]
          execute './configure', *args
        end
      end

      def install
        Dir.chdir('sqlite-autoconf-3080200') do
          bin_path.mkpath
          execute 'make install'
        end
      end
    end
  end
end
