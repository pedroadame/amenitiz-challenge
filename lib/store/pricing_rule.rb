# Describes a pricing rule that affects the total calculation on a cashier
# - type: Any symbol identifying a product type
# - price: How much will each product of the specified type cost once this rule is applied
# - matching: A Hash containing a quantity matching rule key and a number value.
# -- Quantity rules: {exact: 2}, {more_than: 3}, {more_than_or_equals_to: 2}, {less_than: 4}, {less_than_or_equals_to: 4}

class Store::PricingRule
  attr_accessor :type, :price, :matching

  VALID_MATCHINGS = %i[exact
    more_than more_than_or_equals_to
    less_than less_than_or_equals_to]

  def initialize(type = nil, price = nil, matching = nil)
    self.type = type
    self.price = price
    self.matching = matching
  end
  
  def valid?
    if type != nil &&
      price != nil &&
      VALID_MATCHINGS.include?(matching.keys[0])
      true
    else
      false
    end
  end

  def invalid?
    !valid?
  end
end