class ProductQuantity
  attr_reader :product, :quantity

  def initialize(product, weight)
    @product = product
    @quantity = weight
  end

  def eq?(other)
    @product == other.product && @quantity == other.quantity
  end

  def hash
    [@product, @quantity].hash
  end
end
