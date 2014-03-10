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
        prefix_path.parent.mkpath
        FileUtils.rm_rf prefix_path
        execute 'mv', extracted_archive_path + 'go', prefix_path
      end

      def tips
        <<-EOS.unindent
          Set the GOROOT environment variable to /home/action/.parts/bin
            $ export GOROOT=/home/action/.parts/bin
          or add the line above to your ~/.bashrc or ~/.zshrc file

          As of go 1.2, a valid GOPATH is required to use the `go get` command:
            http://golang.org/doc/code.html#GOPATH

          `go vet` and `go doc` are now part of the go.tools sub repo:
            http://golang.org/doc/go1.2#go_tools_godoc

          To get `go vet` and `go doc` run:
            go get code.google.com/p/go.tools/cmd/godoc
            go get code.google.com/p/go.tools/cmd/vet
        EOS
      end
    end
  end
end
