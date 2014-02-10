module Autoparts
  module Commands
    class Start
      def initialize(args, options)
        if args.empty?
          abort <<-EOS.unindent
            Usage: parts start PACKAGE...
            Example: parts start postgresql

            Options:
              --auto: Start service automatically when box boots up
          EOS
        end
        begin
          args.each do |package_name|
            unless Package.installed? package_name
              raise PackageNotInstalledError.new package_name
            end
            package = Package.factory(package_name)
            if package.respond_to? :start
              unless package.running?
                puts "=> Starting #{package_name}..."
                package.start
                puts "=> Started: #{package_name}"
              else
                puts "#{package_name} is already running."
              end

              if options.include?('--auto')
                FileUtils.touch Path.init + "#{package_name}.conf"
                puts "=> Enabled Auto Start: #{package_name}"
              end
            else
              abort "parts: #{package_name} does not support this operation."
            end
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
