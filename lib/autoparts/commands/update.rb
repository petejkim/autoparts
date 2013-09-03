module Autoparts
  module Commands
    class Update
      def initialize(args, options)
        puts "=> Pulling latest changes..."
        Dir.chdir(PROJECT_ROOT) do
          system 'git pull origin master'
        end
      end
    end
  end
end
