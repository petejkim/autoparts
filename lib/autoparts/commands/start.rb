module Autoparts
  module Commands
    class Start
      def initialize(args, options)
        if args.empty?
          abort <<-EOS.unindent
            Usage: parts start PACKAGE...
            Example: parts start postgresql
          EOS
        end
        begin
          args.each do |package_name|
            package = Package.factory(package_name)
            puts "=> Starting #{package_name}..."
            raise StartFailedError.new "#{package_name} is already running." if package.running?
            package.start
            puts "=> Started: #{package_name}"
          end
        rescue StartFailedError => e
          abort "parts: #{e}"
        rescue => e
          abort "parts: ERROR: #{e}\nAborting!"
        end
      end
    end
  end
end
