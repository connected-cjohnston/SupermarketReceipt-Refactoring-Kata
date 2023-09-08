defmodule Models.ReceiptItem do
  defstruct product: nil, quantity: nil, price: nil, total_price: nil

  def initialize(product, quantity, price, total_price) do
    %Models.ReceiptItem{
      product: product,
      quantity: quantity,
      price: price,
      total_price: total_price
    }
  end
end
