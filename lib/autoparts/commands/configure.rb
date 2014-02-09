module Autoparts
  module Commands
    class Configure
      def initialize(args, options)
        if args.empty? || options.empty?
          abort <<-EOS.unindent
            Usage: parts configure PACKAGE...
            Example: parts configure postgresql

            Options:
              --enable-auto-start: Start service when box starts
              --disable-auto-start: Do not start service when box starts
          EOS
        end
        begin
          args.each do |package_name|
            unless Package.installed? package_name
              raise PackageNotInstalledError.new package_name
            end
            package = Package.factory(package_name)
            if package.respond_to? :start
              if options.include?('--enable-auto-start')
                FileUtils.touch Path.init + "#{package_name}.conf"
                puts "=> Enabled Auto Start: #{package_name}"
              elsif options.include?('--disable-auto-start')
                FileUtils.rm_rf Path.init + "#{package_name}.conf"
                puts "=> Disabled Auto Start: #{package_name}"
              end
            else
              abort "parts: #{package_name} does not support this operation."
            end
          end
        rescue => e
          abort "parts: ERROR: #{e}\nAborting!"
        end
      end
    end
  end
end

