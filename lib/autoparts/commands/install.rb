module Autoparts
  module Commands
    class Install
      def initialize(args, options)
        return command(:help).run('install') if args.length == 0
        begin
          args.each do |package_name|
            Package.factory(package_name).perform_install(options.source)
          end
        rescue => e
          abort "ERROR: #{e}\nAborting!"
        end
      end
    end
  end
end
