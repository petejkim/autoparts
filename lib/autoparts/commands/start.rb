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
            package.start
            puts "=> Started: #{package_name}"
          end
        rescue => e
          abort "parts: ERROR: #{e}\nAborting!"
        end
      end
    end
  end
end
