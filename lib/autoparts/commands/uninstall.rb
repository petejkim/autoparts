# Copyright (c) 2013-2014 Irrational Industries Inc. d.b.a. Nitrous.IO
# This software is licensed under the [BSD 2-Clause license](https://raw.github.com/nitrous-io/autoparts/master/LICENSE).

module Autoparts
  module Commands
    class Uninstall
      def initialize(args, options)
        if args.empty?
          abort <<-EOS.unindent
            Usage: parts uninstall PACKAGE... [--version=VERSION]
            Example: parts uninstall postgresql
          EOS
        end
        begin
          installed = Package.installed
          args.each do |package_name|
            unless installed.has_key? package_name
              raise PackageNotInstalledError.new package_name
            end
            pkg = nil
            vopt = options.select {|o| o.start_with? '--version='}.last
            ver = vopt ? vopt.split('=')[1] : nil

            begin
              pkg = Package.factory(package_name)
            rescue Autoparts::PackageNotFoundError => e
            ensure
              if pkg.nil?
                pkg = Class.new(Package) do
                  name(package_name)
                  version(installed[package_name].first)
                end.new
              elsif ver
                pkg.instance_variable_set(:@active_version, ver)
              end
              pkg.perform_uninstall
            end
          end
        rescue => e
          abort "parts: ERROR: #{e}\nAborting!"
        end
      end
    end
  end
end
