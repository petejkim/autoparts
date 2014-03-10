# Copyright (c) 2013-2014 Irrational Industries Inc. d.b.a. Nitrous.IO
# This software is licensed under the [BSD 2-Clause license](https://raw.github.com/nitrous-io/autoparts/master/LICENSE).

require 'unindent/unindent'

module Autoparts
  module Commands
    class Upload
      def initialize(args, options)
        if args.empty?
          abort <<-EOS.unindent
            Usage: parts upload PACKAGE...
            Example: parts upload postgresql
          EOS
        end
        begin
          args.each do |package_name|
            unless Package.installed? package_name
              raise PackageNotInstalledError.new package_name
            end
            Package.factory(package_name).upload_archive
          end
        rescue => e
          abort "parts: ERROR: #{e}\nAborting!"
        end
      end
    end
  end
end

