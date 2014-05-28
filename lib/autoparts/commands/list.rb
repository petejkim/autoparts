# Copyright (c) 2013-2014 Irrational Industries Inc. d.b.a. Nitrous.IO
# This software is licensed under the [BSD 2-Clause license](https://raw.github.com/nitrous-io/autoparts/master/LICENSE).

require 'json'

module Autoparts
  module Commands
    class List
      def initialize(args, options)
        installed = Autoparts::Package.installed

        # json mode outputs the list as a JSON formatted output.
        if options.include?('--json')
          puts JSON.generate installed.map { |n, v| { name: n, versions: v } }
        else
          puts "parts: no installed package found" and return if installed.empty?
          puts installed.map { |p, v| "#{p} (#{v.join(',')})" }
        end
      end
    end
  end
end
