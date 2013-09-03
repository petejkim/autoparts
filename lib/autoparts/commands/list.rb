module Autoparts
  module Commands
    class List
      def initialize(args, options)
        installed = Autoparts::Package.installed
        puts "parts: no installed package found" if installed.length == 0
        installed.each_pair do |package, versions|
          puts "#{package} (#{versions.join ', '})"
        end
      end
    end
  end
end
