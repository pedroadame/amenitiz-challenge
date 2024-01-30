# Describes the main store of the app

class Store
  attr_reader :cart, :stock, :cashier

  def initialize(stock)
    # Available products
    @stock = stock

    # User's cart
    @cart = Store::Cart.new

    # Cashier for total calculation
    @cashier = Store::Cashier.new
  end

  # Adds an item of the given type to the cart
  def add_item(type)
    return unless @stock.key?(type)

    cart.add(@stock[type])
  end

  def total
    @cashier.total(cart)
  end

  def add_pricing_rule(rule)
    @cashier.add_rule(rule)
  end
end
