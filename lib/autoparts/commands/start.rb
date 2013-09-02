module Autoparts
  module Commands
    class Start
      def initialize(args, options)
        return command(:help).run('start') if args.length == 0
        begin
          args.each do |package_name|
            package = Package.factory(package_name)
            puts "=> Starting #{package_name}..."
            package.start
            puts "=> Started: #{package_name}"
          end
        rescue => e
          abort "ERROR: #{e}\nAborting!"
        end
      end
    end
  end
end
