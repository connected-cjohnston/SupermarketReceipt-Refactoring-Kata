require_relative '../lib/models/supermarket_catalog'

class FakeCatalog < SupermarketCatalog
  def initialize
    super
    @products = {}
    @prices = {}
  end

  def add_product(product, price)
    @products[product.name] = product
    @prices[product.name] = price
  end

  def unit_price(product)
    @prices.fetch(product.name)
  end
end
