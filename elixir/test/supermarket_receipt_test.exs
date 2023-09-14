defmodule SupermarketReceiptTest do
  use ExUnit.Case
  doctest SupermarketReceipt

  # alias Models.Product
  # alias Models.Receipt
  # alias Models.ShoppingCart
  # alias Models.SupermarketCatalog
  # alias Models.Teller

  # test "ten percent discount" do
  #   catalog = SupermarketCatalog.initialize()
  #   toothbrush = Product.initialize("toothbrush", :each)
  #   catalog = SupermarketCatalog.add_product(catalog, toothbrush, 0.99)

  #   apples = Product.initialize("apples", :kilo)
  #   catalog = SupermarketCatalog.add_product(catalog, apples, 1.99)

  #   cart = ShoppingCart.initialize()
  #   cart = ShoppingCart.add_item_quantity(cart, apples, 2.5)

  #   teller = Teller.initialize(catalog)
  #   teller = Teller.add_special_offer(teller, :ten_percent_discount, toothbrush, 10.0)

  #   receipt = Teller.checks_out_articles_from(teller, cart)

  #   assert_in_delta(4.975, Receipt.total_price(receipt), 0.01)
  # end
end
