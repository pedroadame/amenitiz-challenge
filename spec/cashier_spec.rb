require './lib/store'
require './lib/store/cashier'

RSpec.describe Store::Cashier do
  before(:each) do
    @store = Store.new
    @cashier = described_class.new
  end

  describe '#initialize' do
    context 'when passing rules' do
      it 'assigns an empty array' do
        cashier = described_class.new
        expect(cashier.rules).to be_empty
      end
    end

    context 'without passing rules' do
      it 'assigns passed rules' do
        cashier = described_class.new([:rule1, :rule2])
        expect(cashier.rules.size).to eq(2)
      end
    end
  end

  describe '#total' do
    context 'with one item' do
      before { @store.add_item(:coffee) }
      it 'returns item total' do
        expect(@cashier.total(@store.cart)).to eq(@store.stock[:coffee][:price])
      end
    end

    context 'without pricing rules' do
      before do
        @store.add_item(:green_tea)
        @store.add_item(:strawberries)
      end

      it 'returns sum of price of all products' do
        expected_price = @store.stock[:green_tea][:price] + @store.stock[:strawberries][:price]
        expect(@cashier.total(@store.cart)).to eq(expected_price)
      end
    end
  end
end