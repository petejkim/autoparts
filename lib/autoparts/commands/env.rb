# Copyright (c) 2013-2014 Irrational Industries Inc. d.b.a. Nitrous.IO
# This software is licensed under the [BSD 2-Clause license](https://raw.github.com/nitrous-io/autoparts/master/LICENSE).

module Autoparts
  module Commands
    class Env
      EXPORTS = {
        'AUTOPARTS_ROOT'             => Path.root,
        'PATH'                       => '$AUTOPARTS_ROOT/bin:$AUTOPARTS_ROOT/sbin:$PATH',
        'LD_LIBRARY_PATH'            => '$AUTOPARTS_ROOT/lib:/usr/local/lib:/usr/lib:$LD_LIBRARY_PATH',
        'LIBRARY_PATH'               => '$AUTOPARTS_ROOT/lib:/usr/local/lib:/usr/lib:$LIBRARY_PATH',
        'DYLD_FALLBACK_LIBRARY_PATH' => '$AUTOPARTS_ROOT/lib',
        'C_INCLUDE_PATH'             => '$AUTOPARTS_ROOT/include',
        'CPLUS_INCLUDE_PATH'         => '$AUTOPARTS_ROOT/include',
        'OBJC_INCLUDE_PATH'          => '$AUTOPARTS_ROOT/include',
        'MAN_PATH'                   => '$AUTOPARTS_ROOT/share/man:/usr/local/share/man:/usr/share/man:$MAN_PATH'
      }.freeze

      def initialize(args, options)
        Env.print_exports
      end

      def self.print_exports
        EXPORTS.each do |envvar, value|
          puts %Q(export #{envvar}="#{value}")
        end
      end
    end
  end
end
