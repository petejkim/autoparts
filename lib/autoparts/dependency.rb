module Autoparts
  class Dependency
    attr_accessor :children

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

    def add_child(*obj)
      @children.push(*obj)
    end

    # get the installation order of the dependency tree. Package that should be
    # installed first will be placed higher in the list
    def install_order
      tree = build_tree self
      tree.sort { |a, b| b[1] <=> a[1] }.map { |d| d[0] }
    end

    # build the reference tree of the current dependency node
    # Each node is assigned a reference counting. The reference counting is
    # used to determine the installation order of the dependency
    def build_tree(root, parent_score=0, tree={})
      tree[name] ||= 0
      tree[name] += 1 + parent_score unless self == root
      @children.each do |c|
        c.build_tree(root, tree[name], tree)
      end
      tree
    end
  end
end
