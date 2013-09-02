module Autoparts
  module Commands
    class Restart
      def initialize(args, options)
        return command(:help).run('restart') if args.length == 0
        begin
          args.each do |package_name|
            package = Package.factory(package_name)
            puts "=> Stopping #{package_name}..."
            package.stop
            puts "=> Starting #{package_name}..."
            package.start
            puts "=> Restarted: #{package_name}"
          end
        rescue => e
          abort "ERROR: #{e}\nAborting!"
        end
      end
    end
  end
end
