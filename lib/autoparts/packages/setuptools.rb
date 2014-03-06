# Copyright (c) 2013-2014 Irrational Industries Inc. d.b.a. Nitrous.IO
# This software is licensed under the [BSD 2-Clause license](https://raw.github.com/nitrous-io/autoparts/master/LICENSE).

module Autoparts
  module Packages
    class Setuptools < Package
      name 'setuptools'
      version '2.2'
      description 'Setuptools: Easily download, build, install, upgrade, and uninstall Python packages'
      source_url 'https://pypi.python.org/packages/source/s/setuptools/setuptools-2.2.tar.gz'
      source_sha1 '547eff11ea46613e8a9ba5b12a89c1010ecc4e51'
      source_filetype 'tgz'
      category Category::DEVELOPMENT_TOOLS

      depends_on "python2"

      def install
        Dir.chdir("setuptools-2.2") do
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
