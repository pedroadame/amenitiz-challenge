require './lib/store'
require './lib/store/pricing_rule'

RSpec.describe Store::PricingRule do
  before(:each) do
    @rule = described_class.new
    @rule.matching = {exact: 2}
    @rule.price = 1.0
    @rule.type = :gr1
    @rule
  end

  describe '#valid?' do
    context 'when matching is one of:' do
      %w[exact more_than more_than_or_equals_to less_than less_than_or_equals_to].each do |match|
        describe match do
          it 'returns true' do
            rule = {match.to_sym => 3}

            @rule.matching = rule
            expect(@rule).to be_valid
          end
        end
      end
    end

    context 'when is another key' do
      it 'returns false' do
        bad_rule = {any: 3}

        @rule.matching = bad_rule
        expect(@rule).to be_invalid
      end
    end
  end
end