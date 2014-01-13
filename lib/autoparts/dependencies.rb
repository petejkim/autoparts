module Autoparts
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
