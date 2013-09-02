module Autoparts
  module Commands
    class Stop
      def initialize(args, options)
        return command(:help).run('stop') if args.length == 0
        begin
          args.each do |package_name|
            package = Package.factory(package_name)
            puts "=> Stopping #{package_name}..."
            package.stop
            puts "=> Stopped: #{package_name}"
          end
        rescue => e
          abort "ERROR: #{e}\nAborting!"
        end
      end
    end
  end
end
