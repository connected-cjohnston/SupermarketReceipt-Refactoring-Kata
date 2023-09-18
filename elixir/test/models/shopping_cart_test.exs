defmodule Models.ShoppingCartTest do
  use ExUnit.Case
  doctest Models.ShoppingCart

  setup do
    {:ok,
     cart: Models.ShoppingCart.initialize(),
     receipt: Models.Receipt.initialize(),
     offer: %Models.Offer{},
     catalog: Models.SupermarketCatalog.initialize()}
  end

  test "ten percent discount", state do
    product = Models.Product.initialize("bread", Models.ProductUnit.each())
    catalog = Models.SupermarketCatalog.add_product(state[:catalog], product, 10.00)
    cart = Models.ShoppingCart.add_item_quantity(state[:cart], product, 1)
    teller = Models.Teller.initialize(catalog)

    teller =
      Models.Teller.add_special_offer(
        teller,
        Models.SpecialOfferType.ten_percent_discount(),
        product,
        10.00
      )

    receipt = Models.ShoppingCart.handle_offers(cart, state[:receipt], teller.offers, catalog)

    assert receipt == %Models.Receipt{
             discounts: [
               %Models.Discount{
                 product: %Models.Product{name: "bread", unit: Models.ProductUnit.each()},
                 description: "10.0% off",
                 discount_amount: 1.0
               }
             ],
             items: []
           }
  end

  test "two for amount", state do
    product = Models.Product.initialize("bread", Models.ProductUnit.each())
    catalog = Models.SupermarketCatalog.add_product(state[:catalog], product, 1.50)
    cart = Models.ShoppingCart.add_item_quantity(state[:cart], product, 2)
    teller = Models.Teller.initialize(catalog)

    teller =
      Models.Teller.add_special_offer(
        teller,
        Models.SpecialOfferType.two_for_amount(),
        product,
        2.00
      )

    receipt = Models.ShoppingCart.handle_offers(cart, state[:receipt], teller.offers, catalog)

    assert receipt == %Models.Receipt{
             discounts: [
               %Models.Discount{
                 description: "2 for 2.0",
                 discount_amount: 1.0,
                 product: %Models.Product{name: "bread", unit: Models.ProductUnit.each()}
               }
             ],
             items: []
           }
  end

  test "three for two", state do
    product = Models.Product.initialize("bread", Models.ProductUnit.each())
    catalog = Models.SupermarketCatalog.add_product(state[:catalog], product, 1.50)
    cart = Models.ShoppingCart.add_item_quantity(state[:cart], product, 3)
    teller = Models.Teller.initialize(catalog)

    teller =
      Models.Teller.add_special_offer(
        teller,
        Models.SpecialOfferType.three_for_two(),
        product,
        1.50
      )

    receipt = Models.ShoppingCart.handle_offers(cart, state[:receipt], teller.offers, catalog)

    assert receipt == %Models.Receipt{
             discounts: [
               %Models.Discount{
                 description: "3 for 2",
                 discount_amount: 1.5,
                 product: %Models.Product{name: "bread", unit: Models.ProductUnit.each()}
               }
             ],
             items: []
           }
  end

  test "five for amount", state do
    product = Models.Product.initialize("bread", Models.ProductUnit.each())
    catalog = Models.SupermarketCatalog.add_product(state[:catalog], product, 1.50)
    cart = Models.ShoppingCart.add_item_quantity(state[:cart], product, 5)
    teller = Models.Teller.initialize(catalog)

    teller =
      Models.Teller.add_special_offer(
        teller,
        Models.SpecialOfferType.five_for_amount(),
        product,
        6.50
      )

    receipt = Models.ShoppingCart.handle_offers(cart, state[:receipt], teller.offers, catalog)

    assert receipt == %Models.Receipt{
             discounts: [
               %Models.Discount{
                 description: "5 for 6.5",
                 discount_amount: 1.0,
                 product: %Models.Product{name: "bread", unit: Models.ProductUnit.each()}
               }
             ],
             items: []
           }
  end
end
