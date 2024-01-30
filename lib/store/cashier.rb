# Describes a cashier that calculates the total of a cart using the provided rules
# A rule must be a PricingRule instance
class Store::Cashier
  attr_accessor :rules

  def initialize
    self.rules = {}
  end

  # Adds a rule to the cashier. Only one type of product per rule
  def add_rule(rule)
    self.rules[rule.type] = rule
  end

  # Calculates the total for a given cart
  def total(cart)
    total = 0.0

    cart.items.each do |item|
      total += item[:price]
    end

    total
  end
end