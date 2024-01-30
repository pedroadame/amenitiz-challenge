RSpec.describe "User uses the Store" do
  before(:each) do
    stock = {
      green_tea: {code: 'GR1', name: 'Green Tea', price: 3.11},
      strawberries: {code: 'SR1', name: 'Strawberries', price: 5.00},
      coffee: {code: 'CF1', name: 'Coffee', price: 11.23}
    }

    rules = [
      Store::PricingRule.new(:gr1, 3.11 * 0.5, {every: 2}),
      Store::PricingRule.new(:sr1, 4.50, {more_than_or_equals_to: 3}),
      Store::PricingRule.new(:cf1, 11.23 * 2/3r, {more_than_or_equals_to: 3})
    ]

    @store = Store.new(rules)
    @store.stock = stock

    @store
  end

  it 'complies with test data 1' do
    @store.scan(:green_tea)
    @store.scan(:green_tea)

    expect(@store.total).to eq(3.11)
  end

  it 'complies with test data 2' do
    @store.scan(:strawberries)
    @store.scan(:strawberries)
    @store.scan(:green_tea)
    @store.scan(:strawberries)

    expect(@store.total).to eq(16.61)
  end
  
  it 'complies with test data 3' do
    @store.scan(:green_tea)
    @store.scan(:coffee)
    @store.scan(:strawberries)
    @store.scan(:coffee)
    @store.scan(:coffee)
    expect(@store.total).to eq(30.57)
  end

  # i.e the 2x1 offer applies to a group of two teas. A third one should be charged at full price
  it 'last green tea in odd quantities is full-priced' do
    @store.scan(:green_tea)
    @store.scan(:green_tea)
    @store.scan(:green_tea)

    expect(@store.total).to eq(6.22)
  end
end