defmodule Models.Teller do
  @moduledoc """
  Functions for working with the Teller
  """
  defstruct catalog: nil, offers: %{}

  alias Models.Offer
  alias Models.Receipt

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

  ## Examples

      iex> product = Models.Product.initialize("bread", :each)
      iex> teller = %Models.Teller{}
      iex> offer = Models.Offer.initialize(:five_for_amount, product, 6.50)
      iex> Models.Teller.add_special_offer(teller, :five_for_amount, product, 6.50)
      %Models.Teller{catalog: nil, offers: %{product => offer}}

  """
  def add_special_offer(teller, offer_type, product, argument) do
    offer = Offer.initialize(offer_type, product, argument)
    %Models.Teller{teller | offers: Map.put(teller.offers, product, offer)}
  end

  @doc """
  Processes each item in a shopping cart

  ## Examples

      iex> product = Models.Product.initialize("bread", :each)
      iex> cart = Models.ShoppingCart.initialize()
      iex> cart = Models.ShoppingCart.add_item(cart, product)
      iex> catalog = Models.SupermarketCatalog.initialize()
      iex> catalog = Models.SupermarketCatalog.add_product(catalog, product, 2.50)
      iex> teller = Models.Teller.initialize(catalog)
      iex> Models.Teller.checks_out_articles_from(teller, cart)
      %Models.Receipt{discounts: [], items: [%Models.ReceiptItem{ price: 2.5, product: %Models.Product{name: "bread", unit: :each}, quantity: 1, total_price: 2.5}]}

  """
  def checks_out_articles_from(teller, cart) do
    receipt = Receipt.initialize()
    product_quantities = cart.items

    receipt = check_out_product(product_quantities, receipt, teller, cart)

    handle_offers(cart, receipt, teller.offers, teller.catalog)
  end

  defp check_out_product([], receipt, _teller, _cart), do: receipt

  defp check_out_product([product_quantity | product_quantities], receipt, teller, cart) do
    product = product_quantity.product
    quantity = product_quantity.quantity
    unit_price = Models.SupermarketCatalog.unit_price(teller.catalog, product)
    price = quantity * unit_price
    receipt = Receipt.add_product(receipt, product, quantity, unit_price, price)

    check_out_product(product_quantities, receipt, teller, cart)
  end

  @doc """
  Handles offers for the products in the shopping cart
  """
  def handle_offers(cart, receipt, offers, catalog) do
    Models.OfferHandler.handle_offer(cart.items, receipt, offers, catalog)
  end
end
