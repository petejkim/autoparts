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
            package = Package.factory(package_name)
            if package.respond_to? :running?
              list[package_name] = package.running?
            end
          end
          unless list.empty?
            ljust_length = list.keys.map(&:length).max + 1
            list.each_pair do |name, running|
              print name.ljust(ljust_length)
              print running ? 'RUNNING' : 'STOPPED'
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
