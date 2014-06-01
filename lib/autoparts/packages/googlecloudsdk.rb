module Autoparts
  module Packages
    class GoogleCloudSDK < Package
      name 'googlecloudsdk'
      version '0.9.25'
      description 'Google Cloud SDK: tools and libraries that enable you to easily create and manage resources on Google Cloud Platform'
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

      def post_install
        bin_path.mkpath
        ['bq', 'gcloud', 'gcutil', 'gsutil'].each do |p|
          execute 'ln', '-s', prefix_path + p, Path.bin + p
        end
      end

      def tips
        <<-EOS.unindent
          Autoparts has installed the Google Cloud SDK and added this tools to
          your path: gcloud, bq, gcutil, gsutil

          To get started, first authenticate with:

            gcloud auth login

          You can update, add and remove components using gcloud:

            gcloud components update        # Update all components
            gcloud components update pkg-go # Install the Go SDK

          For more information about other options:

            gcloud help
            bq help
            gsutil help
            gcutil help
        EOS
      end
    end
  end
end
