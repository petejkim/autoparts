module Autoparts
  module Commands
    class Stop
      def initialize(args, options)
        return command(:help).run('stop') if args.length == 0
        begin
          args.each do |package_name|
            require "autoparts/packages/#{package_name}"
            unless package_class = Package.find(package_name)
              abort "ERROR: #{package_name} not found."
            end
            puts "=> Stopping #{package_name}..."
            package_class.new.stop
            puts "=> Stopped: #{package_name}"
          end
        rescue => e
          abort "ERROR: #{e}\nAborting!"
        end
      end
    end
  end
end
