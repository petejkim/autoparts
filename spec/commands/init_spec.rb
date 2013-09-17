require 'spec_helper'
require 'json'

describe Autoparts::Commands::Init do
  Path = Autoparts::Path

  subject do
    described_class.any_instance.stub :print_exports
    described_class.any_instance.stub :show_help
    described_class.new [], []
  end

  describe '#autoupdate_due?' do
    context 'when update has never been performed before' do
      it 'should return true' do
        expect(subject.autoupdate_due?).to be_true
      end
    end

    context 'when the last update was performed less than a day ago' do
      it 'should return true' do
        Timecop.freeze do
          File.open(Path.partsinfo, 'w') do |f|
            f.write JSON.generate({
              'last_update' => Time.now.to_i - 60 * 60 * 24 + 1
            })
          end
          expect(subject.autoupdate_due?).to be_false
        end
      end
    end

    context 'when the last update was performed greater than or equal to a day ago' do
      it 'should return false' do
        Timecop.freeze do
          File.open(Path.partsinfo, 'w') do |f|
            f.write JSON.generate({
              'last_update' => Time.now.to_i - 60 * 60 * 24
            })
          end
          expect(subject.autoupdate_due?).to be_true
        end
      end
    end
  end
end
