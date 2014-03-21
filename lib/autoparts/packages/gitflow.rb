module Autoparts
  module Packages
    class Gitflow < Package
      name 'gitflow'
      version '0.4.1'
      description 'Gitflow: a collection of Git extensions to provide high-level repository operations for Vincent Driessen\'s branching model.'
      source_url 'https://raw.github.com/nvie/gitflow/master/contrib/gitflow-installer.sh'
      source_sha1 '068fbfd1c33c401b303bfa2bd03678fab1c8f74b'
      source_filetype 'sh'

      category Category::DEVELOPMENT_TOOLS

      def install
        bin_path.mkpath
        ENV['INSTALL_PREFIX'] = bin_path.to_s
        execute 'sh', archive_filename
        execute 'sed', '-i', "s|export GITFLOW_DIR.\\+)|export GITFLOW_DIR=\"#{bin_path}\"|g", bin_path + 'git-flow'
      end

    end
  end
end
