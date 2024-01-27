class Store
  attr_reader :cart

  def initialize
    @cart = Store::Cart.new
  end
end
