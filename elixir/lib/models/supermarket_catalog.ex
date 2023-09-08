defmodule Models.SupermarketCatalog do
  defstruct products: %{}, prices: %{}

  def initialize do
    %Models.SupermarketCatalog{}
  end

  def add_product(catalog, product, price) do
    products = Map.put(catalog.products, product.name, product)
    prices = Map.put(catalog.prices, product.name, price)
    %Models.SupermarketCatalog{products: products, prices: prices}
  end

  def unit_price(catalog, product) do
    Map.fetch(catalog.prices, product.name)
  end
end
