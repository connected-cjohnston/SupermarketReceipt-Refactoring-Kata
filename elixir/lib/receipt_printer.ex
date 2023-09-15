defmodule ReceiptPrinter do
  @moduledoc """
  Functions for printing a supermarket receipt
  """

  @columns 40

  @doc """
  Prints the receipt

  ## Examples

      iex> product = Models.Product.initialize("toothbrush", :each)
      iex> receipt = Models.Receipt.initialize()
      iex> receipt = Models.Receipt.add_product(receipt, product, 1, 0.99, 0.99)
      iex> ReceiptPrinter.print_receipt(receipt)
      "toothbrush                          0.99\\n\\nTotal:                              0.99\\n"

  """
  def print_receipt(receipt) do
    result = ""
    result = print_items(receipt.items, result)

    result = print_discount(receipt.discounts, result)

    result = result <> "\n"
    price_presentation = :erlang.float_to_binary(Models.Receipt.total_price(receipt), decimals: 2)
    total = "Total: "
    whitespace = whitespace(@columns - String.length(total) - String.length(price_presentation))
    result = result <> total <> whitespace <> price_presentation <> "\n"

    result
  end

  defp print_items([], result), do: result

  defp print_items([item | items], result) do
    price = :erlang.float_to_binary(item.total_price, decimals: 2)
    quantity = present_quantity(item)
    name = item.product.name
    unit_price = :erlang.float_to_binary(item.price, decimals: 2)

    whitespace_size = @columns - String.length(name) - String.length(price) - 1
    line = name <> " " <> whitespace(whitespace_size) <> price <> "\n"

    line =
      cond do
        item.quantity != 1 ->
          line <> " " <> unit_price <> " * " <> quantity <> "\n"

        true ->
          line
      end

    result = result <> line

    print_items(items, result)
  end

  defp print_discount([], result), do: result

  defp print_discount([discount | discounts], result) do
    product_presentation = discount.product.name
    price_presentation = :erlang.float_to_binary(discount.discount_amount, decimals: 2)
    description = discount.description

    result = result <> description
    result = result <> "("
    result = result <> product_presentation
    result = result <> ")"

    result =
      result <>
        whitespace(
          @columns - 3 - String.length(product_presentation) - String.length(description) -
            String.length(price_presentation)
        )

    result = result <> "-"
    result = result <> price_presentation
    result = result <> "\n"

    print_discount(discounts, result)
  end

  @doc """
  Formats quantity depending on product unit

  ## Examples

      iex> product = Models.Product.initialize("bread", :each)
      iex> receipt_item = Models.ReceiptItem.initialize(product, 2, 2.0, 4.0)
      iex> ReceiptPrinter.present_quantity(receipt_item)
      "2"

      iex> product = Models.Product.initialize("flour", :kilo)
      iex> receipt_item = Models.ReceiptItem.initialize(product, 2.5, 2.0, 4.0)
      iex> ReceiptPrinter.present_quantity(receipt_item)
      "2.50"

  """
  def present_quantity(item) do
    case item.product.unit do
      :each ->
        "#{item.quantity}"

      :kilo ->
        :erlang.float_to_binary(item.quantity, decimals: 2)
    end
  end

  @doc """
  Creates a string of whitespace of a given size

  ## Examples

      iex> ReceiptPrinter.whitespace(5)
      "     "

  """
  def whitespace(whitespace_size) do
    String.duplicate(" ", whitespace_size)
  end
end
