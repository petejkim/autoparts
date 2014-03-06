# Copyright (c) 2013-2014 Irrational Industries Inc. d.b.a. Nitrous.IO
# This software is licensed under the [BSD 2-Clause license](https://raw.github.com/nitrous-io/autoparts/master/LICENSE).

module Autoparts
  module Packages
    class Pip < Package
      name 'pip'
      version '1.5.4'
      description 'Pip: A tool for installing and managing Python packages'
      source_url 'https://pypi.python.org/packages/source/p/pip/pip-1.5.4.tar.gz'
      source_sha1 '35ccb7430356186cf253615b70f8ee580610f734'
      source_filetype 'tgz'
      category Category::DEVELOPMENT_TOOLS

      depends_on "python2"
      depends_on "setuptools"

      def compile
        Dir.chdir("pip-1.5.4") do
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
