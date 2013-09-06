module Autoparts
  module Commands
    class Purge
      def initialize(args, options)
        if args.empty?
          abort <<-EOS.unindent
            Usage: parts purge PACKAGE...
            Example: parts purge postgresql
          EOS
        end
        begin
          args.each do |package_name|
            unless Package.installed? package_name
              raise PackageNotInstalledError.new package_name
            end
            package = Package.factory(package_name)
            package.perform_uninstall
            package.purge
            puts "=> Purged #{package.name} #{package.version}\n"
          end
        rescue => e
          abort "parts: ERROR: #{e}\nAborting!"
        end
      end
    end
  end
end
