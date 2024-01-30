require './lib/store'
require './lib/store/cart'

RSpec.describe Store::Cart do
  before(:each) do
    @store = generate_store
    @cart = @store.cart
  end

  describe '#empty?' do
    it 'calls @items#empty?' do
      expect(@cart.items).to receive(:empty?)
      @cart.empty?
    end
  end

  describe '#[]' do
    it 'calls @items#[]' do
      expect(@cart.items).to receive(:[])
      @cart[0]
    end
  end

  describe '#add' do
    it 'calls @items#push' do
      green_tea = @store.stock[:green_tea]
      expect(@cart.items).to receive(:push).with(green_tea)
      @cart.add(green_tea)
    end
  end
end