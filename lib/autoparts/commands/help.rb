require 'unindent/unindent'

module Autoparts
  module Commands
    class Help
      def initialize(args, options)
        Dir.chdir(PROJECT_ROOT) do
          git_hash = `git describe --always`.strip
          version = "Autoparts #{Autoparts::VERSION}-#{git_hash}"

          if options.include?('-v') || options.include?('--version')
            puts version
          else
            puts <<-EOS.unindent
              #{version} - A Package Manager for Nitrous.IO

              Usage: parts COMMAND [ARGS...]

              Some useful commands are:
                parts install PACKAGE...   # Install one or many packages
                parts uninstall PACKAGE... # Uninstall one or many packages
                parts list                 # List all installed packages
                parts search [SEARCH_TERM] # Search for a package or list all available packages
                parts start PACKAGE...     # Start one or many services provided by packages
                parts stop PACKAGE...      # Stop one or many services provided by packages
                parts restart PACKAGE...   # Restart one or many services provided by packages
                parts status [PACKAGE...]  # Show status of one or many services provided by packages
                parts update               # Update Autoparts
            EOS
          end
        end
      end
    end
  end
end
