# Copyright (c) 2013-2014 Irrational Industries Inc. d.b.a. Nitrous.IO
# This software is licensed under the [BSD 2-Clause license](https://raw.github.com/nitrous-io/autoparts/master/LICENSE).

module Autoparts
  module Packages
    class Go < Package
      name 'go'
      version '1.2.2'
      description 'Go: An open source programming language that makes it easy to build simple, reliable, and efficient software.'
      category Category::PROGRAMMING_LANGUAGES

      source_url 'https://storage.googleapis.com/golang/go1.2.2.linux-amd64.tar.gz'
      source_sha1 '6bd151ca49c435462c8bf019477a6244b958ebb5'
      source_filetype 'tar.gz'

      def install
        prefix_path.parent.mkpath
        FileUtils.rm_rf prefix_path
        execute 'mv', extracted_archive_path + 'go', prefix_path
      end

      def symlink_all
        # Symlink only binaries
        symlink_recursively(bin_path, Path.bin, only_executables: true)
      end

      def post_install
        gopath.mkpath
      end

      def gopath
        Path.home + 'workspace' + 'go'
      end

      def required_env
        [
          "export GOROOT=#{prefix_path}",
          "export GOPATH=#{gopath}",
          "export PATH=$PATH:$GOPATH/bin"
        ]
      end

      def tips
        tips = <<-EOS.unindent
          Autoparts has added GOROOT and GOPATH environment variables for you.
          To activate go, please restart your shell session.
        EOS
      end
    end
  end
end
