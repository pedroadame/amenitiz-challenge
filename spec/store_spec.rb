require './lib/store'

RSpec.describe Store do
  before(:each) { @store = Store.new }

  context 'when initalized' do
    describe 'user\'s cart' do
      it 'is empty' do
        expect(@store.cart).to be_empty
      end
    end
  end

  context 'when user asks for a product' do
    context 'and the product is green tea' do
      before { @store.add_item(:green_tea) }
      it 'the green tea is added to the user\'s cart' do
        expect(@store.cart[0].code).to eq('GR1')
      end
    end

    context 'and the product is strawberries' do
      before { @store.add_item(:strawberries) }
      it 'strawberries are added to the user\'s cart' do
        expect(@store.cart[0].code).to eq('SR1')
      end
    end

    context 'and the product is a coffee' do
      before { @store.add_item(:coffee) }
      it 'the coffee is added to the user\'s cart' do
        expect(@store.cart[0].code).to eq('CF1')
      end
    end
  end
end
