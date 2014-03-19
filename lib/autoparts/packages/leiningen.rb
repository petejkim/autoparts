# Copyright (c) 2013-2014 Irrational Industries Inc. d.b.a. Nitrous.IO
# This software is licensed under the [BSD 2-Clause license](https://raw.github.com/nitrous-io/autoparts/master/LICENSE).

module Autoparts
  module Packages
    class Leiningen < Package
      name 'leiningen'
      version '2.3.2'
      description 'Leiningen: A build automation and dependency management tool for Clojure'
      category Category::PROGRAMMING_LANGUAGES

      source_url 'https://leiningen.s3.amazonaws.com/downloads/leiningen-2.3.2-standalone.jar'
      source_sha1 'ed6f93be75c796408544042cfd26699d45b49725'
      source_filetype 'jar'

      def install
        prefix_path.mkpath
        execute 'mv', archive_filename, prefix_path

        puts "=> Downloading the lein script..."
        download 'https://raw.github.com/technomancy/leiningen/2.3.2/bin/lein-pkg', tmp_lein_script_path, '4a23609f085add58bc28fb0669a175fe2b26f26f'

        bin_path.mkpath
        execute 'mv', tmp_lein_script_path, lein_executable_path
        execute 'chmod', '0755', lein_executable_path
      end

      def post_install
        execute 'sed', '-i', "s|^LEIN_JAR=.*\.jar|LEIN_JAR=#{prefix_path}/leiningen-#{version}.jar|g", lein_executable_path
      end

      def tmp_lein_script_path
        Path.tmp + "lein-pkg"
      end

      def lein_executable_path
        bin_path + "lein"
      end
    end
  end
end
