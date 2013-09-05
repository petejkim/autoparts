module Autoparts
  module Commands
    class Status
      def initialize(args, options)
        packages = args.length > 0 ? args : Autoparts::Package.installed.keys
        begin
          list = {}
          packages.each do |package_name|
            package = Package.factory(package_name)
            running = package.running?
            list[package_name] = running unless running.nil?
          end
          ljust_length = list.keys.map(&:length).max + 1
          list.each_pair do |name, running|
            print name.ljust(ljust_length)
            print running ? 'RUNNING' : 'STOPPED'
            puts
          end
        rescue => e
          abort "parts: ERROR: #{e}\nAborting!"
        end
      end
    end
  end
end
