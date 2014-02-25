module Autoparts
  module Packages
    class Cloudfoundry < Package
      name 'cloudfoundry'
      version 'v6.0.1'
      description 'Cloud Foundry: An open CLI for managing cloud services'
      source_url 'https://github.com/cloudfoundry/cli/releases/download/v6.0.1/cf-linux-amd64.tgz'
      source_sha1 'e5ab1f9d211f85a1e88e635662be47335313c23b'
      source_filetype 'tgz'

      def install
        bin_path.mkpath
        execute "mv * #{bin_path}"
        execute 'chmod', '0755', cf_executable_path
      end

      def cf_executable_path
        bin_path + 'cf'
      end
    end
  end
end

