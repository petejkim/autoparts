# Copyright (c) 2013-2014 Irrational Industries Inc. d.b.a. Nitrous.IO
# This software is licensed under the [BSD 2-Clause license](https://raw.github.com/nitrous-io/autoparts/master/LICENSE).

module Autoparts
  module Commands
    class Update
      def initialize(args, options)
        puts "=> Updating Autoparts..."
        if self.class.update
          File.open(Path.config_last_update, 'w') do |f|
            f.write JSON.generate({
              'last_update' => Time.now.to_i
            })
          end
        end
      end

      def self.update(silent=false)
        r = nil
        Dir.chdir(PROJECT_ROOT) do
          cmd = 'timeout 15 git pull --rebase origin master'
          r = system(cmd, silent ? { out: '/dev/null', err: '/dev/null' } : {})
        end
        r
      end
    end
  end
end
