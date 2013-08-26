require 'unindent'

module Autoparts
  module Commands
    class Init
      def initialize(args, options)
        if args[0] != '-'
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
        else
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
      end
    end
  end
end
