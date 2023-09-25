defmodule Models.Discount do
  @moduledoc """
  Represents a discount
  """
  defstruct product: nil, description: "", discount_amount: nil

  @doc """
  Returns a new Discount struct with product, description, and discount amount populated
  """
  def initialize(product, description, discount_amount) do
    %Models.Discount{product: product, description: description, discount_amount: discount_amount}
  end

  @doc """
  Creates a Discount for the two for amount offer

  ## Examples

      iex> product = Models.Product.initialize("toothbrush", Models.ProductUnit.each())
      iex> offer = Models.Offer.initialize(Models.SpecialOfferType.two_for_amount(), product, 2.00)
      iex> Models.Discount.two_for_amount_discount(2, offer, 1.50, product)
      %Models.Discount{product: product, description: "2 for 2.0", discount_amount: 1.0}

  """
  def two_for_amount_discount(quantity, offer, unit_price, product) do
    total = offer.argument * (quantity / 2) + rem(quantity, 2) * unit_price
    discount_n = unit_price * quantity - total
    Models.Discount.initialize(product, "2 for #{offer.argument}", discount_n)
  end

  @doc """
  Creates a Discount for the three for two offer

  ## Examples

      iex> product = Models.Product.initialize("toothbrush", Models.ProductUnit.each())
      iex> Models.Discount.three_for_two_discount(3, nil, 1.50, product)
      %Models.Discount{product: product, description: "3 for 2", discount_amount: 1.5}

  """
  def three_for_two_discount(quantity, _offer, unit_price, product) do
    discount_amount =
      quantity * unit_price -
        (quantity / 3 * 2 * unit_price + rem(quantity, 3) * unit_price)

    Models.Discount.initialize(product, "3 for 2", discount_amount)
  end

  @doc """
  Creates a Discount for the five for amount offer

  ## Examples

      iex> product = Models.Product.initialize("bread", Models.ProductUnit.each())
      iex> offer = Models.Offer.initialize(Models.SpecialOfferType.five_for_amount(), product, 4.5)
      iex> Models.Discount.five_for_amount_discount(5, offer, 1.5, product)
      %Models.Discount{product: product, description: "5 for 4.5", discount_amount: 3.0}

  """
  def five_for_amount_discount(quantity, offer, unit_price, product) do
    discount_total =
      unit_price * quantity -
        (offer.argument * (quantity / 5) + rem(quantity, 5) * unit_price)

    Models.Discount.initialize(
      product,
      "5 for #{offer.argument}",
      discount_total
    )
  end

  @doc """
  Creates a Discount for the ten percent discount offer

  ## Examples

      iex> product = Models.Product.initialize("sugar", Models.ProductUnit.each())
      iex> offer = Models.Offer.initialize(Models.SpecialOfferType.ten_percent_discount(), product, 10.0)
      iex> Models.Discount.ten_percent_discount(1, offer, 1.00, product)
      %Models.Discount{product: product, description: "10.0% off", discount_amount: 0.1}

  """
  def ten_percent_discount(quantity, offer, unit_price, product) do
    Models.Discount.initialize(
      product,
      "#{offer.argument}% off",
      quantity * unit_price * offer.argument / 100.0
    )
  end
end
