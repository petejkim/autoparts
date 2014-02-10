module Autoparts
  module Commands
    class Stop
      def initialize(args, options)
        if args.empty?
          abort <<-EOS.unindent
            Usage: parts stop PACKAGE...
            Example: parts stop postgresql
          EOS
        end
        begin
          args.each do |package_name|
            unless Package.installed? package_name
              raise PackageNotInstalledError.new package_name
            end
            package = Package.factory(package_name)
            if package.respond_to? :stop
              if package.running?
                puts "=> Stopping #{package_name}..."
                package.stop
                puts "=> Stopped: #{package_name}"

                if File.exists?(autostart_file = Path.init + "#{package_name}.conf")
                  FileUtils.rm_rf autostart_file
                  puts "=> Disabled Auto Start: #{package_name}"
                end
              else
                puts "#{package_name} does not seem to be running."
              end
            else
              abort "parts: #{package_name} does not support this operation."
            end
          end
        rescue StopFailedError => e
          abort "parts: #{e}"
        rescue => e
          abort "parts: ERROR: #{e}\nAborting!"
        end
      end
    end
  end
end
