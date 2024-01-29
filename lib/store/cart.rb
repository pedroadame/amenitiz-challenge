# Describes an user's shopping cart that holds products
class Store::Cart
  attr_reader :items

  def initialize
    @items = []
  end

  def empty?
    @items.empty?
  end

  def [](index)
    @items[index]
  end

  def add(item)
    @items.push(item)
  end
end
