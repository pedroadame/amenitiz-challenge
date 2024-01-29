# Describes a cashier that calculates the total of a cart using the provided rules
# A rule must be a PricingRule instance
class Store::Cashier
  attr_reader :rules

  def initialize(rules = [])
    # if rules.empty? or rules.all? { |rule| rule.is_a? Store::PricingRule }
    # else raise ArgumentError

    @rules = rules
  end
end