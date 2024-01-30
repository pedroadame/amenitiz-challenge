require './lib/store'
require './lib/store/pricing_rule'

RSpec.describe Store::PricingRule do
  before(:each) { @rule = described_class.new(:green_tea, 1.0, {exact: 2}) }

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


  describe '#applies?' do
    context 'when matching is exact' do
      before(:each) { @rule = described_class.new(:green_tea, 2, {exact: 2}) }

      context 'and has exact items' do
        it 'returns true' do
          items = item_list(2)

          expect(@rule.applies?(items)).to be true
        end
      end

      context 'when has more items than matching value' do
        it 'returns false' do
          items = item_list(3)

          expect(@rule.applies?(items)).to be false
        end
      end

      context 'when there are fewer items than matching value' do
        it 'returns false' do
          items = [new_item]

          expect(@rule.applies?(items)).to be false
        end
      end
    end

    context 'when matching is less_than' do
      before(:each) { @rule = described_class.new(:green_tea, 2, {less_than: 2}) }

      context 'and has exact items' do
        it 'returns false' do
          items = item_list(2)

          expect(@rule.applies?(items)).to be false
        end
      end

      context 'when has more items than matching value' do
        it 'returns false' do
          items = item_list(3)

          expect(@rule.applies?(items)).to be false
        end
      end

      context 'when there are fewer items than matching value' do
        it 'returns true' do
          items = [new_item]

          expect(@rule.applies?(items)).to be true
        end
      end
    end

    context 'when matching is less_than_or_equals_to' do
      before(:each) { @rule = described_class.new(:green_tea, 2, {less_than_or_equals_to: 2}) }

      context 'and has exact items' do
        it 'returns true' do
          items = item_list(2)

          expect(@rule.applies?(items)).to be true
        end
      end

      context 'when has more items than matching value' do
        it 'returns false' do
          items = item_list(3)

          expect(@rule.applies?(items)).to be false
        end
      end

      context 'when there are fewer items than matching value' do
        it 'returns true' do
          items = [new_item]

          expect(@rule.applies?(items)).to be true
        end
      end
    end

    context 'when matching is more_than' do
      before(:each) { @rule = described_class.new(:green_tea, 2, {more_than: 2}) }

      context 'and has exact items' do
        it 'returns false' do
          items = item_list(2)

          expect(@rule.applies?(items)).to be false
        end
      end

      context 'when has more items than matching value' do
        it 'returns true' do
          items = item_list(3)

          expect(@rule.applies?(items)).to be true
        end
      end

      context 'when there are fewer items than matching value' do
        it 'returns false' do
          items = [new_item]

          expect(@rule.applies?(items)).to be false
        end
      end
    end

    context 'when matching is more_than_or_equals_to' do
      before(:each) { @rule = described_class.new(:green_tea, 2, {more_than_or_equals_to: 2}) }

      context 'and has exact items' do
        it 'returns true' do
          items = item_list(2)

          expect(@rule.applies?(items)).to be true
        end
      end

      context 'when has more items than matching value' do
        it 'returns true' do
          items = item_list(3)

          expect(@rule.applies?(items)).to be true
        end
      end

      context 'when there are fewer items than matching value' do
        it 'returns false' do
          items = [new_item]

          expect(@rule.applies?(items)).to be false
        end
      end
    end
  end

  describe '#get_total' do
    it 'returns the sumed up price for every item in the set' do
      items = item_list(4)
      expect(@rule.get_total(items)).to eq(@rule.price * 4)
    end
  end
end
