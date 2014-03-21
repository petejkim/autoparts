# Copyright (c) 2013-2014 Irrational Industries Inc. d.b.a. Nitrous.IO
# This software is licensed under the [BSD 2-Clause license](https://raw.github.com/nitrous-io/autoparts/master/LICENSE).

module Autoparts
  module Packages
    class Virtualenv < Package
      name 'virtualenv'
      version '1.11.4'
      description 'Virtualenv: Virtual Python Environment builder'
      source_url 'https://pypi.python.org/packages/source/v/virtualenv/virtualenv-1.11.4.tar.gz'
      source_sha1 '60b6a01091aa1a88366888ab16e31b9855221d9a'
      source_filetype 'tgz'
      category Category::DEVELOPMENT_TOOLS

      depends_on "python2"

      def compile
        Dir.chdir("virtualenv-1.11.4") do
          args = [
            "-s", "setup.py",
            "--no-user-cfg",
            "install",
            "--force", "--verbose",
            "--prefix=#{prefix_path}",
            "--install-lib=#{python_dependency.site_packages}"
          ]

          execute python_dependency.bin_path + "python", *args
        end
      end

      def python_dependency
        @python ||= get_dependency("python2")
      end
    end
  end
end
