defmodule Models.TellerTest do
  use ExUnit.Case
  doctest Models.Teller

  test "no products in the cart" do
    cart = Models.ShoppingCart.initialize()
    catalog = Models.SupermarketCatalog.initialize()
    teller = Models.Teller.initialize(catalog)

    receipt = Models.Teller.checks_out_articles_from(teller, cart)

    assert receipt == %Models.Receipt{items: [], discounts: []}
  end

  test "1 product in the cart" do
    product = Models.Product.initialize("bread", Models.ProductUnit.each())
    cart = Models.ShoppingCart.initialize()
    cart = Models.ShoppingCart.add_item(cart, product)
    catalog = Models.SupermarketCatalog.initialize()
    catalog = Models.SupermarketCatalog.add_product(catalog, product, 2.50)

    teller = Models.Teller.initialize(catalog)

    receipt = Models.Teller.checks_out_articles_from(teller, cart)

    assert receipt == %Models.Receipt{
             discounts: [],
             items: [
               %Models.ReceiptItem{
                 price: 2.5,
                 product: %Models.Product{name: "bread", unit: Models.ProductUnit.each()},
                 quantity: 1,
                 total_price: 2.5
               }
             ]
           }
  end

  test "should return receipt with two products" do
    product1 = Models.Product.initialize("bread", Models.ProductUnit.each())
    product2 = Models.Product.initialize("cheese", Models.ProductUnit.each())

    catalog = Models.SupermarketCatalog.initialize()
    catalog = Models.SupermarketCatalog.add_product(catalog, product1, 2.55)
    catalog = Models.SupermarketCatalog.add_product(catalog, product2, 5.00)

    cart = Models.ShoppingCart.initialize()
    cart = Models.ShoppingCart.add_item_quantity(cart, product1, 1)
    cart = Models.ShoppingCart.add_item_quantity(cart, product2, 1)

    teller = Models.Teller.initialize(catalog)

    receipt = Models.Teller.checks_out_articles_from(teller, cart)

    assert receipt == %Models.Receipt{
             discounts: [],
             items: [
               %Models.ReceiptItem{
                 product: %Models.Product{name: "bread", unit: Models.ProductUnit.each()},
                 quantity: 1,
                 price: 2.55,
                 total_price: 2.55
               },
               %Models.ReceiptItem{
                 product: %Models.Product{name: "cheese", unit: Models.ProductUnit.each()},
                 quantity: 1,
                 price: 5.0,
                 total_price: 5.0
               }
             ]
           }
  end

  test "should return receipt with 5 loaves of bread" do
    product = Models.Product.initialize("bread", Models.ProductUnit.each())
    catalog = Models.SupermarketCatalog.initialize()
    catalog = Models.SupermarketCatalog.add_product(catalog, product, 2.50)
    cart = Models.ShoppingCart.initialize()
    cart = Models.ShoppingCart.add_item_quantity(cart, product, 5)
    teller = Models.Teller.initialize(catalog)

    receipt = Models.Teller.checks_out_articles_from(teller, cart)

    assert receipt == %Models.Receipt{
             discounts: [],
             items: [
               %Models.ReceiptItem{
                 product: %Models.Product{name: "bread", unit: Models.ProductUnit.each()},
                 quantity: 5,
                 price: 2.5,
                 total_price: 12.5
               }
             ]
           }
  end

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

    receipt = Models.Teller.handle_offers(cart, state[:receipt], teller.offers, catalog)

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

    receipt = Models.Teller.handle_offers(cart, state[:receipt], teller.offers, catalog)

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

    receipt = Models.Teller.handle_offers(cart, state[:receipt], teller.offers, catalog)

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

    receipt = Models.Teller.handle_offers(cart, state[:receipt], teller.offers, catalog)

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
