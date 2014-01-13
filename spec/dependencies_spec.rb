require 'spec_helper'

describe Autoparts::Dependencies do
  it 'initializes like an array' do
    dependencies = described_class.new [1, 2]
    expect(dependencies.to_a).to eql([1, 2])
  end

  describe '#each' do
    it 'iterates all dependencies' do
      dependencies = described_class.new [1]
      dependencies.each do |d|
        expect(d).to eql(1)
      end
    end
  end

  describe '#<<' do
    it 'adds a dependency' do
      dependencies = described_class.new
      dependencies << 1
      dependencies << 2
      dependencies << 1
      expect(dependencies.to_a).to eql([1, 2])
    end
  end

  describe '#include?' do
    it 'tests inclusion of a dependency' do
      dependencies = described_class.new
      expect(dependencies.include?(1)).to be_false
      dependencies << 1
      expect(dependencies.include?(1)).to be_true
    end
  end
end
