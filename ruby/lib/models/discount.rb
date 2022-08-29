class Discount
  attr_reader :product, :description, :discount_amount

  def initialize(product, description, discount_amount)
    @product = product
    @description = description
    @discount_amount = discount_amount
  end

  def ==(other)
    product == other.product && description = other.description && discount_amount && other.discount_amount
  end
end
