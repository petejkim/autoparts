require 'unindent/unindent'

module Autoparts
  module Commands
    class Archive
      def initialize(args, options)
        if args.empty?
          abort <<-EOS.unindent
            Usage: parts archive PACKAGE...
            Example: parts archive postgresql
          EOS
        end
        unless Util.binary_package_compatible?
          abort <<-EOS.unindent
            parts: ERROR: This system is incompatible with binary packages.

            Requirements:
            - Architecture must be x86_64
          EOS
        end
        begin
          args.each do |package_name|
            unless Package.installed? package_name
              raise PackageNotInstalledError.new package_name
            end
            Package.factory(package_name).archive_installed
          end
        rescue => e
          abort "parts: ERROR: #{e}\nAborting!"
        end
      end
    end
  end
end
