defmodule Models.ShoppingCart do
  @moduledoc """
  Functions for a shopping cart
  """
  defstruct items: [], product_quantities: %{}

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
end
