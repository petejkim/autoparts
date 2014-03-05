# Copyright (c) 2013-2014 Irrational Industries Inc. d.b.a. Nitrous.IO
# This software is licensed under the [BSD 2-Clause license](https://raw.github.com/nitrous-io/autoparts/master/LICENSE).

module Autoparts
  module Commands
    class Start
      def initialize(args, options)
        if args.empty?
          abort <<-EOS.unindent
            Usage: parts start PACKAGE...
            Example: parts start postgresql
          EOS
        end
        begin
          args.each do |package_name|
            unless Package.installed? package_name
              raise PackageNotInstalledError.new package_name
            end
            package = Package.factory(package_name)
            if package.respond_to? :start
              FileUtils.touch Path.init + "#{package_name}.conf"
              puts "=> Starting #{package_name}..."
              raise StartFailedError.new "#{package_name} is already running." if package.running?
              package.start
              puts "=> Started: #{package_name}"
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
