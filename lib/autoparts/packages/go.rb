# Copyright (c) 2013-2014 Irrational Industries Inc. d.b.a. Nitrous.IO
# This software is licensed under the [BSD 2-Clause license](https://raw.github.com/nitrous-io/autoparts/master/LICENSE).

module Autoparts
  module Packages
    class Go < Package
      name 'go'
      version '1.2.1'
      description 'Go: An open source programming language that makes it easy to build simple, reliable, and efficient software.'
      category Category::PROGRAMMING_LANGUAGES

      source_url 'https://go.googlecode.com/files/go1.2.1.linux-amd64.tar.gz'
      source_sha1 '7605f577ff6ac2d608a3a4e829b255ae2ebc8dcf'
      source_filetype 'tar.gz'

      def install
        goroot.parent.mkpath
        FileUtils.rm_rf goroot
        execute 'mv', extracted_archive_path + 'go', goroot
      end

      def symlink_all
        # Manage symlinking ourselves.
        go_binaries = Dir[goroot + 'bin' + '*']
        execute 'ln', '-s', *go_binaries, Path.bin
      end

      def post_install
        gopath.mkpath
      end

      def goroot
        prefix_path
      end

      def gopath
        Path.home + 'workspace' + 'go'
      end

      def required_env
        [
          "export GOROOT=#{goroot}",
          "export GOPATH=#{gopath}",
          "export PATH=$PATH:$GOPATH/bin"
        ]
      end

      def tips
        tips = <<-EOS.unindent
          The Go package requires the GOROOT and GOPATH environment variables to be set.
          You'll probably also want to include $GOPATH/bin in your PATH.

          Autoparts has already setup those environment variables for you:
          you just need to start a new shell session.

          Alternatively, you can add these lines to your ~/.bashrc or ~/.zshrc file:
        EOS
        tips + required_env.join("\n")
      end
    end
  end
end
