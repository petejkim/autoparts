module Autoparts
  module Commands
    class Archive
      def initialize(args, options)
        return command(:help).run('archive') if args.length == 0
        begin
          args.each do |package_name|
            unless Package.installed? package_name
              raise PackageNotInstalledError.new package_name
            end
            require "autoparts/packages/#{package_name}"
            unless package_class = Package.find(package_name)
              abort "ERROR: #{package_name} not found."
            end
            package_class.new.archive_installed
          end
        rescue => e
          abort "ERROR: #{e}\nAborting!"
        end
      end
    end
  end
end
