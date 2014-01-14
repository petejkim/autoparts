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

    def ==(other)
      instance_of?(other.class) && name == other.name
    end
    alias_method :eql?, :==

    def perform_install_with_dependencies(*args)
      dependencies.install_order.each do |pkg|
        unless Package.installed?(pkg)
          Package.factory(pkg).perform_install(*args)
        end
      end
      perform_install
    end

    # returns the package for specified dependency
    def get_dependency(name)
      dep = dependencies.find { |d| d.name == name }
      dep.obj if dep
    end

    def dependencies
      @dep ||= Dependency.new(self)
      if self.class.dependencies && !self.class.dependencies.empty?
        self.class.dependencies.each do |klass|
          d = klass.new.dependencies
          @dep.add_child d unless @dep.children.include?(d)
        end
      end
      @dep
    end
  end
end
