# Copyright (c) 2013-2014 Irrational Industries Inc. d.b.a. Nitrous.IO
# This software is licensed under the [BSD 2-Clause license](https://raw.github.com/nitrous-io/autoparts/master/LICENSE).

module Autoparts
  module Commands
    class Install
      def initialize(args, options)
        if args.empty?
          abort <<-EOS.unindent
            Usage: parts install PACKAGE... [OPTION]
            Example: parts install postgresql

            Options:
              --source : Install from source
          EOS
        end
        begin
          tips = []
          args.each do |package_name|
            tips.concat(Package.factory(package_name).perform_install_with_dependencies(options.include? '--source'))
          end

          tips.each do | message |
            puts message
          end
        rescue => e
          abort "parts: ERROR: #{e}\nAborting!"
        end
      end
    end
  end
end
