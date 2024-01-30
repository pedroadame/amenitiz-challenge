# Describes a cashier that calculates the total of a cart using the provided rules
# A rule must be a PricingRule instance
class Store::Cashier
  attr_accessor :rules

  def initialize
    self.rules = {}
  end

  # Adds a rule to the cashier. Only one type of product per rule
  def add_rule(rule)
    rules[rule.type] = rule
  end

  # Calculates the total for a given cart
  def total(cart)
    total = 0.0

    grouped = cart.items.group_by { |item| item[:code].downcase.to_sym }

    grouped.keys.each do |item_type|
      rule = rules[item_type]
      if rule&.valid?
        total += apply_rule(rule, grouped[item_type])
      else
        total += grouped[item_type].map { |x| x[:price] }.inject(:+)
      end
    end

    total
  end

  # Returns sumed total for the given rule's item type of all matching items
  # in cart
  def apply_rule(rule, items)
    0.0
  end
end