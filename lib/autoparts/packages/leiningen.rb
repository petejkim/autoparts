module Autoparts
  module Packages
    class Leiningen < Package
      name 'leiningen'
      version '2.3.2'
      description 'Leiningen: Build automation and dependency management tool for Clojure'
      source_url "https://leiningen.s3.amazonaws.com/downloads/leiningen-2.3.2-standalone.jar"
      source_sha1 'ed6f93be75c796408544042cfd26699d45b49725'
      source_filetype 'jar'

      def install
        prefix_path.mkpath
        execute 'mv', archive_filename, prefix_path

        setup_lein_script
      end

      def post_install
        if @source_install
          execute 'sed', '-i', "s|^LEIN_JAR=.*\.jar|LEIN_JAR=#{prefix_path}/leiningen-#{version}.jar|g", lein_executable_path
        end
      end

      def setup_lein_script
        download_lein_script

        bin_path.mkpath
        execute 'mv', tmp_lein_script_path, lein_executable_path
        execute 'chmod', '0755', lein_executable_path
      end

      def download_lein_script
        # sha1 need to be checked?
        puts "=> Downloading the lein script..."
        url = "https://raw.github.com/technomancy/leiningen/2.3.2/bin/lein-pkg"
        execute 'curl', url, '-L', '-o', tmp_lein_script_path
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
