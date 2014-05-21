# Copyright (c) 2013-2014 Irrational Industries Inc. d.b.a. Nitrous.IO
# This software is licensed under the [BSD 2-Clause license](https://raw.github.com/nitrous-io/autoparts/master/LICENSE).

module Autoparts
  module Packages
    class Apr < Package
      name 'apr'
      version '1.5.1'
      description 'Apache Portable Runtime: Software libraries that provide a predictable and consistent interface to underlying platform-specific implementations'
      category Category::LIBRARIES

      source_url 'http://mirrors.gigenet.com/apache//apr/apr-1.5.1.tar.gz'
      source_sha1 '9caa83e3f50f3abc9fab7c4a3f2739a12b14c3a3'
      source_filetype 'tar.gz'

      def compile
        Dir.chdir('apr-1.5.1') do
          args = [
            "--prefix=#{prefix_path}",
            "--bindir=#{bin_path}",
            "--sbindir=#{bin_path}",
            "--sysconfdir=#{Path.etc}",
            "--libdir=#{lib_path}",
            "--includedir=#{include_path}",
            "--datarootdir=#{share_path}/#{name}",
            "--datadir=#{share_path}/#{name}",
            "--mandir=#{man_path}",
            "--docdir=#{doc_path}",
          ]

          execute './configure', *args
          execute 'make'
        end
      end


      def install
        Dir.chdir('apr-1.5.1') do
          execute 'make install'
        end
      end
    end
  end
end
