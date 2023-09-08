defmodule Models.Receipt do
  defstruct items: [], discounts: []

  alias Models.ReceiptItem

  def initialize do
    %Models.Receipt{}
  end

  def total_price(receipt) do
    total = Enum.sum(receipt.items.total_price)
    discounts = Enum.sum(receipt.discounts.discount_amount)
    total - discounts
  end

  def add_product(receipt, product, quantity, price, total_price) do
    item = ReceiptItem.initialize(product, quantity, price, total_price)
    %Models.Receipt{receipt | items: [item | receipt.items]}
  end
end
