require 'unindent'

module Autoparts
  module Commands
    class Archive
      def initialize(args, options)
        return command(:help).run('archive') if args.length == 0
        unless Util.binary_package_compatible?
          abort <<-STR.unindent
            ERROR: This system is incompatible with Nitrous.IO binary packages.

            Requirements:
            - Architecture must be x86_64
            - Username must be "action"
            - Packages must be installed into '/home/action/.parts/packages'
          STR
        end
        begin
          args.each do |package_name|
            unless Package.installed? package_name
              raise PackageNotInstalledError.new package_name
            end
            Package.factory(package_name).archive_installed
          end
        rescue => e
          abort "ERROR: #{e}\nAborting!"
        end
      end
    end
  end
end
