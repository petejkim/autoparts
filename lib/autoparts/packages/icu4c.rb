# Copyright (c) 2013-2014 Irrational Industries Inc. d.b.a. Nitrous.IO
# This software is licensed under the [BSD 2-Clause license](https://raw.github.com/nitrous-io/autoparts/master/LICENSE).

module Autoparts
  module Packages
    class ICU4C < Package
      name 'icu4c'
      version '53.1'
      description 'ICU4C: Provides Unicode and Globalization support for software applications'
      category Category::LIBRARIES

      source_url "http://download.icu-project.org/files/icu4c/53.1/icu4c-53_1-src.tgz"
      source_sha1 '7eca017fdd101e676d425caaf28ef862d3655e0f'
      source_filetype 'tar.gz'

      def compile
        Dir.chdir('icu/source') do
          args = [
            # path
            "--prefix=#{prefix_path}",
            "--exec-prefix=#{prefix_path}",
            "--bindir=#{bin_path}",
            "--sbindir=#{bin_path}",
            "--sysconfdir=#{Path.etc}",
            "--libdir=#{lib_path}",
            "--includedir=#{include_path}",
            "--datadir=#{share_path}/#{name}",
            "--mandir=#{man_path}",
            "--disable-samples",
            "--disable-tests",
            "--enable-static",
          ]
          execute './configure', *args
          execute 'make'
        end
      end

      def install
        Dir.chdir('icu/source') do
          execute 'make install'
        end
      end
    end
  end
end
