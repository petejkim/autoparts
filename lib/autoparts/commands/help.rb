require 'unindent/unindent'

module Autoparts
  module Commands
    class Help
      def initialize(args, options)
        puts <<-EOS.unindent
          Autoparts #{Autoparts::VERSION} A Package Manager for Nitrous.IO

          Usage: parts COMMAND [ARGS...]

          Some useful commands are:
            parts install PACKAGE...      # Install one or many packages
            parts uninstall PACKAGE...    # Uninstall one or many packages
            parts list                    # List all installed packages
            parts start PACKAGE...        # Start one or many services provided by packages
            parts stop PACKAGE...         # Stop one or many services provided by packages
            parts restart PACKAGE...      # Restart one or many services provided by packages
            parts update                  # Update Autoparts
        EOS
      end
    end
  end
end
