RSpec.describe "User uses the Store" do
  before(:each) do
    stock = {
      green_tea: {code: 'GR1', name: 'Green Tea', price: 3.11},
      strawberries: {code: 'SR1', name: 'Strawberries', price: 5.00},
      coffee: {code: 'CF1', name: 'Coffee', price: 11.23}
    }

    @store = Store.new(stock)
    @store.add_pricing_rule(Store::PricingRule.new(:gr1, 3.11 * 0.5, {exact: 2}))
    @store.add_pricing_rule(Store::PricingRule.new(:sr1, 4.50, {more_than_or_equals_to: 3}))
    @store.add_pricing_rule(Store::PricingRule.new(:cf1, 11.23 * 2/3r, {more_than_or_equals_to: 3}))

    @store
  end

  it 'complies with test data 1' do
    @store.add_item(:green_tea)
    @store.add_item(:green_tea)

    expect(@store.total).to eq(3.11)
  end
  
  it 'complies with test data 2' do
    @store.add_item(:strawberries)
    @store.add_item(:strawberries)
    @store.add_item(:green_tea)
    @store.add_item(:strawberries)

    expect(@store.total).to eq(16.61)
  end
  
  it 'complies with test data 3' do
    @store.add_item(:green_tea)
    @store.add_item(:coffee)
    @store.add_item(:strawberries)
    @store.add_item(:coffee)
    @store.add_item(:coffee)
    expect(@store.total).to eq(30.57)
  end
end