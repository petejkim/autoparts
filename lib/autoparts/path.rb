# Copyright (c) 2013-2014 Irrational Industries Inc. d.b.a. Nitrous.IO
# This software is licensed under the [BSD 2-Clause license](https://raw.github.com/nitrous-io/autoparts/master/LICENSE).

module Autoparts
  module Path
    class << self
      def mkpath(pathname)
        pathname.mkpath
        pathname
      end

      def root
        path = File.expand_path(ENV['AUTOPARTS_ROOT'] || '~/.parts')
        mkpath(Pathname.new path)
      end

      def home
        Pathname.new(Dir.home)
      end

      def archives; mkpath(root + 'archives') end
      def bin;      mkpath(root + 'bin')      end
      def etc;      mkpath(root + 'etc')      end
      def include;  mkpath(root + 'include')  end
      def lib;      mkpath(root + 'lib')      end
      def packages; mkpath(root + 'packages') end
      def sbin;     mkpath(root + 'sbin')     end
      def share;    mkpath(root + 'share')    end
      def tmp;      mkpath(root + 'tmp')      end
      def var;      mkpath(root + 'var')      end

      def config;   mkpath(root + '.config')  end

      def config_autostart
        config + 'autostart'
      end

      def config_last_update
        root + 'last_update'
      end
    end
  end
end
