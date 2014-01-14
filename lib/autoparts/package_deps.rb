module Autoparts
  module PackageDeps
    module ClassMethods
      attr_accessor :dependencies

      def depends_on(pkg)
        @dependencies ||= []
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
      @dependencies ||= []
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

    def perform_install_with_dependencies(*args)
      dependencies_tree.install_order.each do |pkg|
        Package.factory(pkg).perform_install
      end
    end

    def get_dependency(name)
      dependencies.find { |d| d.name == name }
    end

    def dependencies_tree
      dep = Dependency.new(self)
      dependencies.each do |d|
        dep.add_child d.dependencies_tree
      end
      dep
    end
  end
end
