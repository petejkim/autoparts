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
            package = Package.factory(package_name)
            puts "=> Stopping #{package_name}..."
            package.stop
            puts "=> Stopped: #{package_name}"
          end
        rescue => e
          abort "parts: ERROR: #{e}\nAborting!"
        end
      end
    end
  end
end
