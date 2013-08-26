module Autoparts
  module Commands
    class Install
      def initialize(args, options)
        return command(:help).run('install') if args.length == 0
        begin
          args.each do |package_name|
            require "autoparts/packages/#{package_name}"
            unless package_class = Package.find(package_name)
              abort "ERROR: #{package_name} not found."
            end
            package_class.new.perform_install(options.source)
          end
        rescue => e
          abort "ERROR: #{e}\nAborting!"
        end
      end
    end
  end
end
