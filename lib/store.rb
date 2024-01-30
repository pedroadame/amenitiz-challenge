# Describes the main store of the app

class Store
  # Available products
  attr_accessor :stock

  attr_reader :cart, :cashier

  def initialize(pricing_rules = [])
    # User's cart
    @cart = Store::Cart.new

    # Cashier for total calculation
    @cashier = Store::Cashier.new
    pricing_rules.each { |rule| @cashier.add_rule(rule) }
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
