# Copyright (c) 2013-2014 Irrational Industries Inc. d.b.a. Nitrous.IO
# This software is licensed under the [BSD 2-Clause license](https://raw.github.com/nitrous-io/autoparts/master/LICENSE).

require 'json'

module Autoparts
  module Commands
    class Status
      def initialize(args, options)
        packages = args.length > 0 ? args : Autoparts::Package.installed.keys
        begin
          list = {}
          packages.each do |package_name|
            unless Package.installed? package_name
              raise PackageNotInstalledError.new package_name
            end
            begin
              package = Package.factory(package_name)
            rescue PackageNotFoundError => e
            end
            if package.respond_to? :running?
              list[package_name] = package.running? ? 'running' : 'stopped'
            end
          end

          # json mode outputs the list as a JSON formatted output.
          if options.include?('--json')
            puts JSON.generate list.map { |n, s| { name: n, status: s } }
          else
            return if list.empty?

            ljust_length = list.keys.map(&:length).max + 1

            list.each_pair do |name, status|
              print name.ljust(ljust_length)
              print status.upcase
              puts
            end
          end
        rescue => e
          abort "parts: ERROR: #{e}\nAborting!"
        end
      end
    end
  end
end
