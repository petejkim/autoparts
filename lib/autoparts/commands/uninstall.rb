module Autoparts
  module Commands
    class Uninstall
      def initialize(args, options)
        return command(:help).run('uninstall') if args.length == 0
        begin
          args.each do |package_name|
            unless Package.installed? package_name
              raise PackageNotInstalledError.new package_name
            end
            Package.factory(package_name).perform_uninstall
          end
        rescue => e
          abort "ERROR: #{e}\nAborting!"
        end
      end
    end
  end
end
