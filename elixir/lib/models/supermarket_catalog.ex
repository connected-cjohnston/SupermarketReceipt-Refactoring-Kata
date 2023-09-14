defmodule Models.SupermarketCatalog do
  defstruct products: %{}, prices: %{}

  @doc """
  Creates a new empty catalog
  """
  def initialize do
    %Models.SupermarketCatalog{}
  end

  @doc """
  Adds a product to the given catalog

  ## Examples

      iex> product = Models.Product.initialize("sword", :each)
      iex> catalog = Models.SupermarketCatalog.initialize()
      iex> Models.SupermarketCatalog.add_product(catalog, product, 2.55)
      %Models.SupermarketCatalog{ products: %{ "sword" => product }, prices: %{ "sword" => 2.55 }}

  """
  def add_product(catalog, product, price) do
    products = Map.put(catalog.products, product.name, product)
    prices = Map.put(catalog.prices, product.name, price)
    %Models.SupermarketCatalog{products: products, prices: prices}
  end

  @doc """
  Finds the unit price for the given product

  ## Examples

      iex> product = Models.Product.initialize("sword", :each)
      iex> catalog = Models.SupermarketCatalog.initialize()
      iex> catalog = Models.SupermarketCatalog.add_product(catalog, product, 2.55)
      iex> Models.SupermarketCatalog.unit_price(catalog, product)
      2.55

  """
  def unit_price(catalog, product) do
    {:ok, unit_price} = Map.fetch(catalog.prices, product.name)
    unit_price
  end
end
