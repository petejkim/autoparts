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
          args.each do |package_name|
            Package.factory(package_name).perform_install_with_dependencies(options.include? '--source')
          end
        rescue => e
          p e.backtrace
          abort "parts: ERROR: #{e}\nAborting!"
        end
      end
    end
  end
end
