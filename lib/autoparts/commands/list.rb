# Copyright (c) 2013-2014 Irrational Industries Inc. d.b.a. Nitrous.IO
# This software is licensed under the [BSD 2-Clause license](https://raw.github.com/nitrous-io/autoparts/master/LICENSE).

module Autoparts
  module Commands
    class List
      def initialize(args, options)
        installed = Autoparts::Package.installed
        puts "parts: no installed package found" if installed.length == 0
        installed.each_pair do |package, versions|
          puts "#{package} (#{versions.join ', '})"
        end
      end
    end
  end
end
