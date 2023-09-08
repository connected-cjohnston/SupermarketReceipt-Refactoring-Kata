defmodule Models.Teller do
  @moduledoc """
  Functions for working with the Teller
  """
  defstruct catalog: nil, offers: %{}

  alias Models.Offer
  alias Models.Receipt
  alias Models.ShoppingCart

  @doc """
  Returns a new Teller with a given catalog

  ## Examples

      iex> Models.Teller.initialize(%Models.SupermarketCatalog{})
      %Models.Teller{catalog: %Models.SupermarketCatalog{products: %{}, prices: %{}}, offers: %{}}

  """
  def initialize(catalog) do
    %Models.Teller{catalog: catalog}
  end

  @doc """
  Adds a special offer to the teller
  """
  def add_special_offer(teller, offer_type, product, argument) do
    offers = [Offer.initialize(offer_type, product, argument) | teller.offers]
    %Models.Teller{teller | offers: offers}
  end

  @doc """
  Processes each item in a shopping cart
  """
  def checks_out_articles_from(teller, cart) do
    receipt = Receipt.initialize()
    product_quantities = cart.items

    receipt =
      Enum.each(product_quantities, fn pq ->
        product = pq.product
        quantity = pq.quantity
        unit_price = teller.catalog.unit_price(teller.catalog, product)
        price = quantity * unit_price
        Receipt.add_product(receipt, product, quantity, unit_price, price)
      end)

    ShoppingCart.handle_offers(cart, receipt, teller.offers, teller.catalog)
  end
end
