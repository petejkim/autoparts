module Autoparts
  module Commands
    class Update
      def initialize(args, options)
        puts "=> Updating Autoparts..."
        if self.class.update
          File.open(Path.partsinfo, 'w') do |f|
            f.write JSON.generate({
              'last_update' => Time.now.to_i
            })
          end
          puts "=> Updated: #{Help.version}"
        end
      end

      def self.update(silent=false)
        r = nil
        Dir.chdir(PROJECT_ROOT) do
          cmd = 'git pull --rebase origin master'
          r = system(cmd, silent ? { out: '/dev/null', err: '/dev/null' } : {})
        end
        r
      end
    end
  end
end
