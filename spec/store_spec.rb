require './lib/store'

RSpec.describe Store do
  before(:each) { @store = generate_store }

  context 'when initalized' do
    describe 'user\'s cart' do
      it 'is empty' do
        expect(@store.cart).to be_empty
      end
    end
  end

  context 'when assigning stock' do
    it 'converts prices to BigDecimal' do
      stock = { product: { code: 'a', name: 'test', price: 1.00 } }
      @store.stock = stock
      expect(@store.stock[:product][:price]).to be_a(BigDecimal)
    end
  end

  context 'when user asks for a product' do
    context 'and the product is green tea' do
      before { @store.scan(:green_tea) }
      it 'the green tea is added to the user\'s cart' do
        expect(@store.cart[0][:code]).to eq('GR1')
      end
    end

    context 'and the product is strawberries' do
      before { @store.scan(:strawberries) }
      it 'strawberries are added to the user\'s cart' do
        expect(@store.cart[0][:code]).to eq('SR1')
      end
    end

    context 'and the product is a coffee' do
      before { @store.scan(:coffee) }
      it 'the coffee is added to the user\'s cart' do
        expect(@store.cart[0][:code]).to eq('CF1')
      end
    end

    context 'and the product does not exist' do
      it 'bypasses the add intent' do
        expect(@store.cart).to_not receive(:add)

        @store.scan(:shoes)
      end
    end
  end

  describe '#total' do
    it 'asks cashier for the total' do
      expect(@store.cashier).to receive(:total)

      @store.total
    end
  end

  describe '#add_pricing_rule' do
    it 'asks cashier to add rule' do
      expect(@store.cashier).to receive(:add_rule)

      rule = Store::PricingRule.new(:voucher, 2, {exact: 2})

      @store.add_pricing_rule(rule)
    end
  end
end
