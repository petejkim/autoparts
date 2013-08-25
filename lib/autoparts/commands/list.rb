module Autoparts
  module Commands
    class List
      def initialize(args, options)
        Autoparts::Package.installed.each_pair do |package, versions|
          puts "#{package} (#{versions.join ', '})"
        end
      end
    end
  end
end
