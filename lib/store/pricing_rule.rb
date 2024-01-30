# Describes a pricing rule that affects the total calculation on a cashier
# - type: Any symbol identifying a product type
# - price: How much will each product of the specified type cost once this rule is applied
# - matching: A Hash containing a quantity matching rule key and a number value.
# -- Quantity rules: {exact: 2}, {more_than: 3}, {more_than_or_equals_to: 2}, {less_than: 4}, {less_than_or_equals_to: 4}

class Store::PricingRule
  attr_accessor :type, :price, :matching

    VALID_MATCHINGS = {
      exact: :==,
      more_than: :>,
      more_than_or_equals_to: :>=,
      less_than: :<,
      less_than_or_equals_to: :<=
  }

  def initialize(type = nil, price = nil, matching = nil)
    self.type = type
    self.price = price
    self.matching = matching
  end
  
  def valid?
    if type != nil &&
      price != nil &&
      VALID_MATCHINGS.keys.include?(matching.keys[0])
      true
    else
      false
    end
  end

  def invalid?
    !valid?
  end


  # Checks whether a set of items matches with this rule
  def applies?(items)
    items.size.public_send(VALID_MATCHINGS[matching_type], matching_value)
  end

  # Calculates the total for an item set based on the rule set price
  def get_total(items)
    price * items.size
  end

  private

  def matching_type
    matching.keys[0]
  end

  def matching_value
    matching.values[0]
  end
end