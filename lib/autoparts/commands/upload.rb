require 'unindent/unindent'

module Autoparts
  module Commands
    class Upload
      def initialize(args, options)
        if args.empty?
          abort <<-EOS.unindent
            Usage: parts upload PACKAGE...
            Example: parts upload postgresql
          EOS
        end
        begin
          args.each do |package_name|
            unless Package.installed? package_name
              raise PackageNotInstalledError.new package_name
            end

            package = Package.factory(package_name)
            binary_file_name = "#{package.name_with_version}-binary.tar.gz"
            binary_sha1_file_name = "#{package.name_with_version}-binary.sha1"

            Package.factory(package_name).upload_archive
          end
        rescue => e
          abort "parts: ERROR: #{e}\nAborting!"
        end
      end
    end
  end
end

