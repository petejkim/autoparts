# Copyright (c) 2013-2014 Irrational Industries Inc. d.b.a. Nitrous.IO
# This software is licensed under the [BSD 2-Clause license](https://raw.github.com/nitrous-io/autoparts/master/LICENSE).

require 'unindent/unindent'
require 'json'

module Autoparts
  module Commands
    class Init
      def initialize(args, options)
        if options.first == '-'
          # NOTE: a common usage of parts init is `eval $(parts init -)`.
          # Ensure that everything run below does not have stray output
          no_autoupdate_env = ENV['AUTOPARTS_NO_AUTOUPDATE']
          if autoupdate_due? && !(no_autoupdate_env && ['1', 'true'].include?(no_autoupdate_env.downcase))
            if Update.update(true)
              File.open(Path.config_last_update, 'w') do |f|
                f.write JSON.generate({
                  'last_update' => Time.now.to_i
                })
              end
              # rerun in case the code changes from underneath us break anything
              if File.basename($0) == 'parts' && File.executable?($0)
                exec({'AUTOPARTS_NO_AUTOUPDATE' => '1'}, "#{$0} init #{(options + args).join(' ')}")
              end
            end
          end
          Env.print_exports
        elsif options.include? '--start'
          Autoparts::Package.start_all
        else
          show_help
        end
      end

      def show_help
        profile = case ENV['SHELL']
        when /bash/
          '~/.bashrc'
        when /zsh/
          '~/.zshrc'
        else
          'your profile'
        end
        puts <<-STR.unindent
          # Load environment variables for Autoparts automatically by
          # adding the following to #{profile}

          eval "$(parts init -)"
        STR
      end

      def autoupdate_due?
        info = nil
        begin
          info = JSON.parse(File.read(Path.config_last_update.to_s))
        rescue
        end

        !info || !info['last_update'] || (info['last_update'].to_i <= Time.now.to_i - 60 * 60 * 24)
      end
    end
  end
end
