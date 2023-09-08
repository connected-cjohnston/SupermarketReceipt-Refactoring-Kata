defmodule SupermarketReceiptTest do
  use ExUnit.Case
  doctest SupermarketReceipt

  alias Models.SupermarketCatalog
  alias Models.Product

  test "ten percent discount" do
    catalog = SupermarketCatalog.initialize()
    toothbrush = Models.Product.initialize("toothbrush", :each)
    catalog = SupermarketCatalog.add_product(catalog, toothbrush, 0.99)

    apples = Product.initialize("apples", :kilo)
    catalog = SupermarketCatalog.add_product(catalog, apples, 1.99)

    cart = Models.ShoppingCart.initialize()
    cart = Models.ShoppingCart.add_item_quantity(cart, apples, 2.5)

    teller = Models.Teller.initialize(catalog)
    teller = Models.Teller.add_special_offer(teller, :ten_percent_discount, toothbrush, 10.0)

    receipt = Models.Teller.checks_out_articles_from(teller, cart)

    assert_in_delta(4.975, receipt.total_price, 0.01)
  end
end
