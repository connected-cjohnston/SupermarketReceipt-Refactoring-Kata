defmodule Models.ShoppingCart do
  defstruct items: [], product_quantities: %{}

  def initialize do
    %Models.ShoppingCart{}
  end

  def items do
    []
  end

  def add_item(shopping_cart, product) do
    add_item_quantity(shopping_cart, product, 1)
  end

  def product_quantities(shopping_cart) do
    shopping_cart.product_quantities
  end

  def add_item_quantity(shopping_cart, product, quantity) do
    product_quantity = %Models.ProductQuantity{product: product, quantity: quantity}
    items = [product_quantity | shopping_cart.items]

    product_quantities =
      Map.update(shopping_cart.product_quantities, product.name, quantity, fn existing_value ->
        existing_value + quantity
      end)

    %Models.ShoppingCart{items: items, product_quantities: product_quantities}
  end

  def handle_offers(cart, receipt, offers, catalog) do
    receipt
  end
end
