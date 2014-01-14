module Autoparts
  class Dependency
    def initialize(obj)
      @obj = obj
      @children = []
    end

    def name
      @obj.name
    end

    def ==(other)
      instance_of?(other.class) && name == other.name
    end
    alias_method :eql?, :==

    def add_child(obj)
      @children << obj
    end

    def install_order
      tree = build_tree self
      tree.sort { |a, b| b[1] <=> a[1] }.map { |d| d[0] }
    end

    def build_tree(root, tree={})
      tree[name] ||= 0
      tree[name] += 1 unless self == root
      @children.each do |c|
        c.build_tree(root, tree)
      end
      tree
    end
  end

  class Dependencies
    include Enumerable

    def initialize(*args)
      @deps = Array.new(*args)
    end

    def each(*args, &block)
      @deps.each(*args, &block)
    end

    def <<(d)
      @deps << d unless @deps.include? d
      self
    end

    def to_a
      @deps
    end
  end
end
