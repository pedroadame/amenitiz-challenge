# Describes a cashier that calculates the total of a cart using the provided rules
# A rule must be a PricingRule instance
class Store::Cashier
  attr_reader :rules

  def initialize(rules = [])
    # if rules.empty? or rules.all? { |rule| rule.is_a? Store::PricingRule }
    # else raise ArgumentError

    @rules = rules
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