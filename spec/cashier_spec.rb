require './lib/store'
require './lib/store/cashier'
require './lib/store/cart'
require './lib/store/pricing_rule'

RSpec.describe Store::Cashier do
  before(:each) do
    @store = generate_store
    @cashier = described_class.new
  end

  describe '#initialize' do
    it 'assigns an empty hash for rules' do
      cashier = described_class.new
      expect(cashier.rules.keys).to be_empty
    end
  end

  describe '#total' do
    context 'with one item' do
      before { @store.scan(:coffee) }
      it 'returns item total' do
        expect(@cashier.total(@store.cart)).to eq(@store.stock[:coffee][:price])
      end
    end

    context 'without pricing rules' do
      before do
        @store.scan(:green_tea)
        @store.scan(:strawberries)
      end

      it 'returns sum of price of all products' do
        expected_price = @store.stock[:green_tea][:price] + @store.stock[:strawberries][:price]
        expect(@cashier.total(@store.cart)).to eq(expected_price)
      end
    end

    context 'with pricing rules' do
      before do
        @store.scan(:green_tea)
        @store.scan(:strawberries)
        @rule = Store::PricingRule.new(:gr1, 1.5, {exact: 1})
        @invalid_rule = Store::PricingRule.new(:st1, 1.5, {any: 1})
        @cashier.add_rule(@rule)
        @cashier.add_rule(@invalid_rule)
      end

      it 'applies only valid rules' do
        expect(@cashier).to receive(:apply_rule).with(@rule, [@store.cart[0]]).and_call_original
        expect(@cashier).to_not receive(:apply_rule).with(@invalid_rule, [@store.cart[1]]).and_call_original

        @cashier.total(@store.cart)
      end
    end
  end

  describe '#add_rule' do
    it 'adds a rule to list' do
      rule = Store::PricingRule.new(:green_tea, 1.5, {exact: 2})
      expect(@cashier.rules.keys.size).to eq(0)
      @cashier.add_rule(rule)
      expect(@cashier.rules.keys.size).to eq(1)
    end
  end

  describe '#apply_rule' do
    before(:each) { @rule = Store::PricingRule.new(:green_tea, 2, {exact: 2}) }
    context 'when is suitable for items' do
      it 'returns the sum of the rule price' do
        items = item_list(2)

        # Private method
        price = @cashier.send :apply_rule, @rule, items

        expect(price).to eq(4.00)
      end
    end

    context 'when is not' do
      it 'returns the sum of the original price' do
        items = item_list(3)

        # Private method
        price = @cashier.send :apply_rule, @rule, items

        expect(price).to eq(15.00)
      end
    end
  end
end