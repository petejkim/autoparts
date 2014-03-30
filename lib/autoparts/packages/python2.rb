# Copyright (c) 2013-2014 Irrational Industries Inc. d.b.a. Nitrous.IO
# This software is licensed under the [BSD 2-Clause license](https://raw.github.com/nitrous-io/autoparts/master/LICENSE).

module Autoparts
  module Packages
    class Python2 < Package
      name 'python2'
      version '2.7.6-1'
      description 'Python 2: The most friendly Programming Language'
      source_url 'http://www.python.org/ftp/python/2.7.6/Python-2.7.6.tgz'
      source_sha1 '8328d9f1d55574a287df384f4931a3942f03da64'
      source_filetype 'tgz'
      category Category::PROGRAMMING_LANGUAGES

      def compile
        Dir.chdir(python_version) do
          args = [
            "--prefix=#{prefix_path}",
            "--enable-shared",            
          ]
          execute "./configure", *args
          execute "make"
        end
      end

      def install
        Dir.chdir(python_version) do
          execute "make install"
        end
      end

      def python_version
        "Python-2.7.6"
      end

      def site_packages
        p = prefix_path + "lib" + "python#{common_version}" + "site-packages"
        p.mkpath unless p.exist?
        p
      end
      
      def common_version
        "2.7"
      end
    end
  end
end
