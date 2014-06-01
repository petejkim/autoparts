module Autoparts
  module Packages
    class GoogleCloudSDK < Package
      name 'googlecloudsdk'
      version '0.9.25'
      description 'Google Cloud SDK: Tools and libraries to easily create and manage resources on Google Cloud Platform'
      category Category::UTILITIES

      source_url 'https://dl.google.com/dl/cloudsdk/release/google-cloud-sdk.tar.gz'
      source_sha1 '1c8194f38a995f0db31b1f0a306de04b7fe107fd'
      source_filetype 'tar.gz'

      def install
        prefix_path.parent.mkpath
        FileUtils.rm_rf prefix_path
        execute 'mv', extracted_archive_path + 'google-cloud-sdk', prefix_path
        args = [
          '--usage-reporting=false',
          '--bash-completion=false',
          '--path-update=false',
          '--disable-installation-options',
          '--rc-path=/tmp/.bashrc'
          ]
        execute "#{prefix_path}/install.sh", *args
      end
      
      def symlink_all
        # Avoid linking as we added the tools to PATH
      end

      def required_env
        # We put the bin folder from Google Cloud SDK into PATH
        # so new components installed can work properly.
        [
          "export PATH=$PATH:#{prefix_path}/bin"
        ]
      end

      def tips
        <<-EOS.unindent
          Autoparts has installed the Google Cloud SDK and added it's
          binaries in your PATH environment variable.
          You can restart your shell to use the tools: gcloud, bq,
          gcutil and gsutil.

          To get started, first authenticate your box with:

            gcloud auth login

          You can update, add and remove components using gcloud command:

            gcloud components update        # Update all components
            gcloud components update pkg-go # Install the Go SDK

          All tools accept a 'help' command that display usage tips.
        EOS
      end
    end
  end
end
