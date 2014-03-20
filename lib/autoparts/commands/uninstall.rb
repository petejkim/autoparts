# Copyright (c) 2013-2014 Irrational Industries Inc. d.b.a. Nitrous.IO
# This software is licensed under the [BSD 2-Clause license](https://raw.github.com/nitrous-io/autoparts/master/LICENSE).

module Autoparts
  module Commands
    class Uninstall
      def initialize(args, options)
        if args.empty?
          abort <<-EOS.unindent
            Usage: parts uninstall PACKAGE...
            Example: parts uninstall postgresql
          EOS
        end
        begin
          args.each do |package_name|
            unless Package.installed? package_name
              raise PackageNotInstalledError.new package_name
            end
            Package.factory(package_name).perform_uninstall
          end
        rescue => e
          abort "parts: ERROR: #{e}\nAborting!"
        end
      end
    end
  end
end
