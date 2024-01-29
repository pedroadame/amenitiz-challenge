class Store
  attr_reader :cart, :stock

  def initialize
    @cart = Store::Cart.new
    @stock = {
      green_tea: {code: 'GR1', name: 'Green Tea', price: 3.11},
      strawberries: {code: 'SR1', name: 'Strawberries', price: 5.00},
      coffee: {code: 'CF1', name: 'Coffee', price: 11.23}
    }
  end

  def add_item(type)
    @cart.add(@stock[type])
  end
end
