module Autoparts
  module Packages
    class Tree < Package
      name 'tree'
      version '1.7.0'
      description 'Tree is a recursive directory listing command'
      category Category::UTILITIES

      source_url 'http://mama.indstate.edu/users/ice/tree/src/tree-1.7.0.tgz'
      source_sha1 '35bd212606e6c5d60f4d5062f4a59bb7b7b25949'
      source_filetype 'tgz'

      def compile
        Dir.chdir('tree-1.7.0') do
          execute 'make'
        end
      end

      def install
        Dir.chdir('tree-1.7.0') do
          execute 'make', "prefix=#{prefix_path}", 'install'
        end
      end
    end
  end
end
