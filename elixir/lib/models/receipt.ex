defmodule Models.Receipt do
  @moduledoc """
  Functions for a Receipt
  """
  defstruct items: [], discounts: []

  alias Models.ReceiptItem

  @doc """
  Creates a new Receipt struct
  """
  def initialize do
    %Models.Receipt{}
  end

  @doc """
  Calculates the total price of all products in the receipt

  ## Examples

      iex> product = Models.Product.initialize("product", :each)
      iex> discount = Models.Discount.initialize(product, "discount", 1.00)
      iex> receipt = Models.Receipt.initialize
      iex> receipt = Models.Receipt.add_product(receipt, product, 3, 1.50, 4.50)
      iex> receipt = Models.Receipt.add_discount(receipt, discount)
      iex> Models.Receipt.total_price(receipt)
      3.5

  """
  def total_price(receipt) do
    total = Enum.sum(Enum.map(receipt.items, fn item -> item.total_price end))
    discount = Enum.sum(Enum.map(receipt.discounts, fn discount -> discount.discount_amount end))
    total - discount
  end

  @doc """
  Adds a product to the receipt

  ## Examples

      iex> product = Models.Product.initialize("product", :each)
      iex> receipt = Models.Receipt.initialize()
      iex> Models.Receipt.add_product(receipt, product, 2, 1.00, 2.00)
      %Models.Receipt{items: [Models.ReceiptItem.initialize(product, 2, 1.00, 2.00)], discounts: []}

  """
  def add_product(receipt, product, quantity, price, total_price) do
    item = ReceiptItem.initialize(product, quantity, price, total_price)
    %Models.Receipt{receipt | items: [item | receipt.items]}
  end

  @doc """
  Adds a discount, if given one, to the receipt

  ## Examples

      iex> Models.Receipt.add_discount(Models.Receipt.initialize, nil)
      %Models.Receipt{items: [], discounts: []}

      iex> discount = %Models.Discount{product: nil, description: "nil product", discount_amount: 2.59}
      iex> Models.Receipt.add_discount(Models.Receipt.initialize, discount)
      %Models.Receipt{items: [], discounts: [discount]}

  """
  def add_discount(receipt, discount) do
    if discount == nil do
      receipt
    else
      %Models.Receipt{receipt | discounts: [discount | receipt.discounts]}
    end
  end
end
