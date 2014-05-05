# Copyright (c) 2013-2014 Irrational Industries Inc. d.b.a. Nitrous.IO
# This software is licensed under the [BSD 2-Clause license](https://raw.github.com/nitrous-io/autoparts/master/LICENSE).

module Autoparts
  module Packages
    class Rust < Package
      name 'rust'
      version '0.10'
      description 'Rust: A safe, concurrent, practical language'
      category Category::PROGRAMMING_LANGUAGES

      source_url 'http://static.rust-lang.org/dist/rust-0.10.tar.gz'
      source_sha1 '20460730047ca6694eeb780d990f566572c32c43'
      source_filetype 'tar.gz'

      def install
        Dir.chdir('rust-0.10') do
          execute 'make', 'install'
        end
      end

      def compile
        Dir.chdir('rust-0.10') do
          args = [
            "--prefix=#{prefix_path}"
          ]

          execute './configure', *args
          execute 'make'
        end
      end
    end
  end
end
