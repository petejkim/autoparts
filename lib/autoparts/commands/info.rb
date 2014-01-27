module Autoparts
  module Commands
    class Info
      def initialize(args, options)
        if args.empty?
          abort <<-EOS.unindent
            Usage: parts info PACKAGE... [OPTION]
            Example: parts info postgresql
          EOS
        end
        begin
          args.each do |package_name|
            package = Package.factory(package_name)
            puts "#{package.name} (#{package.version})"
            puts package.description
            puts "=> Dependencies: #{package.dependencies}" if package.dependencies.count > 0
            if package.tips
              puts '=> Tips:'
              puts package.tips
            end
          end
        rescue => e
          abort "parts: ERROR: #{e}\nAborting!"
        end
      end
    end
  end
end
