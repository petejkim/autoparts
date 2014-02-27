module Autoparts
  module Commands
    class Install
      def initialize(args, options)
        if args.empty?
          abort <<-EOS.unindent
            Usage: parts install PACKAGE... [OPTION]
            Example: parts install postgresql

            Options:
              --source : Install from source
          EOS
        end
        begin
          tips = []
          args.each do |package_name|
            tips.concat(Package.factory(package_name).perform_install_with_dependencies(options.include? '--source'))
          end

          tips.each do | message |
            puts message
          end
        rescue => e
          abort "parts: ERROR: #{e}\nAborting!"
        end
      end
    end
  end
end
