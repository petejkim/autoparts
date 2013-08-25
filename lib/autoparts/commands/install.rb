module Autoparts
  module Commands
    class Install
      def initialize(args, options)
        return command(:help).run('install') if args.length == 0
        args.each do |package_name|
          require "autoparts/packages/#{package_name}"
          unless package_class = Package.find(package_name)
            abort "ERROR: #{package_name} not found."
          end
          package_class.new.install_from_source
        end
      end
    end
  end
end
