# Copyright (c) 2013-2014 Irrational Industries Inc. d.b.a. Nitrous.IO
# This software is licensed under the [BSD 2-Clause license](https://raw.github.com/nitrous-io/autoparts/master/LICENSE).

require 'json'

module Autoparts
  module Commands
    class Search
      def initialize(args, options)
        begin
          Pathname.new("#{PROJECT_ROOT}/lib/autoparts/packages").children.sort.each do |f|
            require "autoparts/packages/#{f.basename.sub_ext('')}" if f.extname == '.rb'
          end
        rescue LoadError
        end

        packages = Package.packages
        if args.length > 0
          packages = packages.select { |name, _| name.include? args[0] }
        end

        if packages.length > 0
          list = {}
          packages.each_pair do |name, package_class|
            package = package_class.new
            list["#{name} (#{package.version})"] = { name: name,
                                                     version: package.version,
                                                     category: package.category,
                                                     description: package.description }
          end

          # json mode outputs the list as a JSON formatted output.
          if options.include?('--json')
            puts JSON.generate list.values
          else
            return if list.empty?

            ljust_length = list.keys.map(&:length).max + 1
            list.each_pair do |name, package|
              print name.ljust(ljust_length)
              print package[:description] if package[:description]
              puts
            end
          end
        else
          abort "parts: no package found for \"#{args[0]}\""
        end
      end
    end
  end
end
