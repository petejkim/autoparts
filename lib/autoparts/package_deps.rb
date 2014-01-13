module Autoparts
  module PackageDeps
    module ClassMethods
      attr_accessor :dependencies

      def depends_on(pkg)
        @dependencies ||= Dependencies.new
        begin
          require "autoparts/packages/#{pkg}"
        rescue LoadError
        end
        @dependencies << packages[pkg]
      end
    end

    def self.included(base)
      base.extend ClassMethods
    end

    def dependencies
      @dependencies ||= Dependencies.new
      if self.class.dependencies
        self.class.dependencies.each do |d|
          @dependencies << d.new
        end
      end
      @dependencies
    end

    def ==(other)
      instance_of?(other.class) && name == other.name
    end
    alias_method :eql?, :==

    def install_with_dependencies
      dependencies.each do |d|
        d.install_with_dependencies
      end
      install
    end
  end
end
