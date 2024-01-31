require 'bigdecimal'

# Describes the main store of the app
class Store
  attr_reader :cart, :cashier, :stock

  def initialize(pricing_rules = [])
    # User's cart
    @cart = Store::Cart.new

    # Cashier for total calculation
    @cashier = Store::Cashier.new
    pricing_rules.each { |rule| @cashier.add_rule(rule) }
  end

  # Adds an item of the given type to the cart
  def scan(type)
    return unless @stock.key?(type)

    cart.add(@stock[type])
  end

  def total
    @cashier.total(cart)
  end

  def add_pricing_rule(rule)
    @cashier.add_rule(rule)
  end

  def stock=(stock)
    @stock = stock.each_with_object({}) do |(k, v), h|
      v[:price] = BigDecimal(v[:price], 8)
      h[k] = v
    end
  end
end
