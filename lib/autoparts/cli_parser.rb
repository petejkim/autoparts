# Copyright (c) 2013-2014 Irrational Industries Inc. d.b.a. Nitrous.IO
# This software is licensed under the [BSD 2-Clause license](https://raw.github.com/nitrous-io/autoparts/master/LICENSE).

module Autoparts
  class CLIParser
    attr_reader :argv, :command, :options, :args

    def initialize(argv)
      @argv = argv
      parse
    end

    protected
    def parse
      @command = nil
      @options = []
      @args = []

      @argv.each do |a|
        if a.start_with? '-'
          @options << a
        else
          if @command.nil?
            @command = a
          else
            @args << a
          end
        end
      end
    end
  end
end
