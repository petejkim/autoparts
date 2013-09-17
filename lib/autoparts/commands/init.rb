require 'unindent/unindent'
require 'json'

module Autoparts
  module Commands
    class Init
      def initialize(args, options)
        if options.first == '-'
          no_autoupdate_env = ENV['AUTOPARTS_NO_AUTOUPDATE']
          if autoupdate_due? && !(no_autoupdate_env && ['1', 'true'].include?(no_autoupdate_env.downcase))
            print 'autoparts: updating...'
            if Update.update(true)
              File.open(Path.partsinfo, 'w') do |f|
                f.write JSON.generate({
                  'last_update' => Time.now.to_i
                })
              end
              puts 'done'
            else
              puts 'failed'
            end
          end
          print_exports
        else
          show_help
        end
      end

      def print_exports
        puts <<-STR.unindent
          export AUTOPARTS_ROOT="#{Path.root}"
          export PATH="$AUTOPARTS_ROOT/bin:$AUTOPARTS_ROOT/sbin:$PATH"
          export LD_LIBRARY_PATH="$AUTOPARTS_ROOT/lib:/usr/local/lib:/usr/lib"
          export LIBRARY_PATH="$AUTOPARTS_ROOT/lib:/usr/local/lib:/usr/lib"
          export DYLD_FALLBACK_LIBRARY_PATH="$AUTOPARTS_ROOT/lib"
          export C_INCLUDE_PATH="$AUTOPARTS_ROOT/include"
          export CPLUS_INCLUDE_PATH="$AUTOPARTS_ROOT/include"
          export OBJC_INCLUDE_PATH="$AUTOPARTS_ROOT/include"
          export MAN_PATH="$AUTOPARTS_ROOT/share/man:/usr/local/share/man:/usr/share/man"
        STR
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
          info = JSON.parse(File.read(Path.partsinfo.to_s))
        rescue
        end

        !info || !info['last_update'] || (info['last_update'].to_i <= Time.now.to_i - 60 * 60 * 24)
      end
    end
  end
end
