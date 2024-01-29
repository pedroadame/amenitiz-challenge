# Describes the main store of the app

class Store
  attr_reader :cart, :stock, :cashier

  def initialize
    # User's cart
    @cart = Store::Cart.new

    # Available products
    @stock = {
      green_tea: {code: 'GR1', name: 'Green Tea', price: 3.11},
      strawberries: {code: 'SR1', name: 'Strawberries', price: 5.00},
      coffee: {code: 'CF1', name: 'Coffee', price: 11.23}
    }

    # Cashier for total calculation
    @cashier = Store::Cashier.new
  end

  # Adds an item of the given type to the cart
  def add_item(type)
    return unless @stock.key?(type)

    @cart.add(@stock[type])
  end
end
