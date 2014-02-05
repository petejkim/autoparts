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
      def env;      mkpath(root + 'env') end

      def partsinfo
        root + '.partsinfo'
      end
    end
  end
end
