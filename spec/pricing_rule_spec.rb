require './lib/store'
require './lib/store/pricing_rule'

RSpec.describe Store::PricingRule do
  before(:each) { @rule = described_class.new(:green_tea, 1.0, {exact: 2}) }

  context 'when initialized' do
    it 'converts price to BigDecimal' do
      expect(@rule.price).to be_a(BigDecimal)
    end
  end

  context 'when assigning price' do
    it 'converts price to BigDecimal' do
      @rule.price = 2.00
      expect(@rule.price).to be_a(BigDecimal)
    end
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

    context 'when matching is every' do
      before(:each) { @rule = described_class.new(:voucher, 2, {every: 2}) }

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
    context 'when matching is every' do
      # every: 2, items.size <= 3
      context 'and only one matching set of items' do
        context 'and has no resting item' do
          it 'applies the price for every set of items' do
            items = item_list(2)
            @rule.matching = {every: 2}

            # Standard price: 5.00 (total 10.00),
            # expected price: 1.00 in two items (2.00)
            expect(@rule.get_total(items)).to eq(@rule.price * 2)
          end
        end

        context 'and has resting item' do
          it 'applies the price for every set of items' do
            items = item_list(3)
            @rule.matching = {every: 2}

            # Standard price: 5.00 (total 15.00),
            # expected price: 1.00 in two items, 5.00 in the rest (7.00)
            expect(@rule.get_total(items)).to eq(@rule.price * 2 + items[-1][:price])
          end
        end

      end

      # every: 2, items.size >= 4
      context 'and more than one set of items' do
        context 'and no resting item' do
          it 'applies the price for every set of items' do
            items = item_list(4)
            @rule.matching = {every: 2}

            # Standard price: 5.00 (total 25.00),
            # expected price: 1.00 in four items (4.00)
            expect(@rule.get_total(items)).to eq(@rule.price * 4)
          end
        end

        context 'and has resting item' do
          it 'applies the price for every set of items' do
            items = item_list(5)
            @rule.matching = {every: 2}

            # Standard price: 5.00 (total 25.00),
            # expected price: 1.00 in four items, 5.00 in the rest (9.00)
            expect(@rule.get_total(items)).to eq(@rule.price * 4 + items[-1][:price])
          end
        end
      end

      # every: 2, items.size == 1
      context 'and no set of items' do
        it 'applies the price only for every set of items' do
          items = item_list(1)
          @rule.matching = {every: 2}

          # Standard price: 5.00),
          # expected price: 5.00 (no items group)
          expect(@rule.get_total(items)).to eq(items[0][:price])
        end
      end

    end

    Store::PricingRule::VALID_MATCHINGS.keys.reject { |x| x == :every }.each do |key|
      context "when matching is #{key}" do
        it 'returns the sumed up price of all items' do
          items = item_list(4)
          @rule.matching = {key => 2}
          expect(@rule.get_total(items)).to eq(@rule.price * 4)
        end
      end
    end
  end
end
