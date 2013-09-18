module Autoparts
  module Packages
    class Leiningen < Package
      name 'leiningen'
      version '2.3.2'
      description 'Leiningen: Build automation and dependency management tool for Clojure'
      source_url 'https://leiningen.s3.amazonaws.com/downloads/leiningen-2.3.2-standalone.jar'
      source_sha1 'ed6f93be75c796408544042cfd26699d45b49725'
      source_filetype 'jar'
      binary_url 'https://nitrousio-autoparts-use1.s3.amazonaws.com/leiningen-2.3.2-binary.tar.gz'
      binary_sha1 '61204033e6bedda4514e7372d9101fa14e9b0e1a'

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
