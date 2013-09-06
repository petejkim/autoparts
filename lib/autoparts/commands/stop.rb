module Autoparts
  module Commands
    class Stop
      def initialize(args, options)
        if args.empty?
          abort <<-EOS.unindent
            Usage: parts stop PACKAGE...
            Example: parts stop postgresql
          EOS
        end
        begin
          args.each do |package_name|
            unless Package.installed? package_name
              raise PackageNotInstalledError.new package_name
            end
            package = Package.factory(package_name)
            puts "=> Stopping #{package_name}..."
            raise StopFailedError.new "#{package_name} does not seem to be running." unless package.running?
            package.stop
            puts "=> Stopped: #{package_name}"
          end
        rescue StopFailedError => e
          abort "parts: #{e}"
        rescue => e
          abort "parts: ERROR: #{e}\nAborting!"
        end
      end
    end
  end
end
