defmodule Models.ShoppingCart do
  @moduledoc """
  Functions for a shopping cart
  """
  defstruct items: [], product_quantities: %{}

  alias Models.Discount

  @doc """
  Returns an empty shopping cart

  ## Examples

      iex> Models.ShoppingCart.initialize()
      %Models.ShoppingCart{}

  """
  def initialize do
    %Models.ShoppingCart{}
  end

  @doc """
  Adds a single item to the shopping cart

  ## Examples

      iex> Models.ShoppingCart.add_item(%Models.ShoppingCart{}, %Models.Product{name: "apples", unit: :each})
      %Models.ShoppingCart{items: [%Models.ProductQuantity{product: %Models.Product{name: "apples", unit: :each}, quantity: 1}], product_quantities: %{%Models.Product{name: "apples", unit: :each} => 1}}

  """
  def add_item(shopping_cart, product) do
    add_item_quantity(shopping_cart, product, 1)
  end

  @doc """
  Adds a given quantity of a product to the shopping cart

  ## Examples

      iex> Models.ShoppingCart.add_item_quantity(%Models.ShoppingCart{}, %Models.Product{name: "product", unit: :each}, 2)
      %Models.ShoppingCart{items: [%Models.ProductQuantity{product: %Models.Product{name: "product", unit: :each}, quantity: 2}], product_quantities: %{%Models.Product{name: "product", unit: :each} => 2}}

  """
  def add_item_quantity(shopping_cart, product, quantity) do
    product_quantity = %Models.ProductQuantity{product: product, quantity: quantity}

    items = [product_quantity | shopping_cart.items]

    product_quantities =
      Map.update(shopping_cart.product_quantities, product, quantity, fn existing_value ->
        existing_value + quantity
      end)

    %Models.ShoppingCart{items: items, product_quantities: product_quantities}
  end

  @doc """
  Handles offers for the products in the shopping cart
  """
  def handle_offers(cart, receipt, offers, catalog) do
    handle_offer(cart.items, receipt, offers, catalog)
  end

  defp handle_offer([], receipt, _offers, _catalog), do: receipt

  defp handle_offer([product_quantity | product_quantities], receipt, offers, catalog) do
    product = product_quantity.product
    quantity = product_quantity.quantity
    price = Models.SupermarketCatalog.unit_price(catalog, product)
    unit_price = Models.SupermarketCatalog.unit_price(catalog, product)

    discount =
      case Map.fetch(offers, product) do
        {:ok, offer} ->
          cond do
            offer.offer_type == :ten_percent_discount ->
              Models.Discount.initialize(
                product,
                "#{offer.argument}% off",
                quantity * unit_price * offer.argument / 100.0
              )

            offer.offer_type == :two_for_amount ->
              total = offer.argument * (quantity / 2) + rem(quantity, 2) * unit_price
              discount_n = unit_price * quantity - total
              Models.Discount.initialize(product, "2 for #{offer.argument}", discount_n)

            offer.offer_type == :three_for_two ->
              number_of_x = quantity / 3

              discount_amount =
                quantity * unit_price -
                  (number_of_x * 2 * unit_price + rem(quantity, 3) * unit_price)

              Models.Discount.initialize(product, "3 for 2", discount_amount)

            true ->
              nil
          end

        :error ->
          nil
      end

    receipt =
      Models.Receipt.add_product(
        receipt,
        product,
        quantity,
        price,
        price * quantity
      )

    receipt = Models.Receipt.add_discount(receipt, discount)

    handle_offer(product_quantities, receipt, offers, catalog)
  end
end
