# Describes the main store of the app

class Store
  attr_reader :cart, :stock

  def initialize
    # User's cart
    @cart = Store::Cart.new

    # Available products
    @stock = {
      green_tea: {code: 'GR1', name: 'Green Tea', price: 3.11},
      strawberries: {code: 'SR1', name: 'Strawberries', price: 5.00},
      coffee: {code: 'CF1', name: 'Coffee', price: 11.23}
    }
  end

  # Adds an item of the given type to the cart
  def add_item(type)
    @cart.add(@stock[type])
  end
end
