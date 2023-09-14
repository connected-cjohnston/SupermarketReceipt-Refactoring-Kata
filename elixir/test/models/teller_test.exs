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
    product = Models.Product.initialize("bread", :each)
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
                 product: %Models.Product{name: "bread", unit: :each},
                 quantity: 1,
                 total_price: 2.5
               }
             ]
           }
  end

  test "should return receipt with two products" do
    product1 = Models.Product.initialize("bread", :each)
    product2 = Models.Product.initialize("cheese", :each)

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
                 product: %Models.Product{name: "bread", unit: :each},
                 quantity: 1,
                 price: 2.55,
                 total_price: 2.55
               },
               %Models.ReceiptItem{
                 product: %Models.Product{name: "cheese", unit: :each},
                 quantity: 1,
                 price: 5.0,
                 total_price: 5.0
               }
             ]
           }
  end

  test "should return receipt with 5 loaves of bread" do
    product = Models.Product.initialize("bread", :each)
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
                 product: %Models.Product{name: "bread", unit: :each},
                 quantity: 5,
                 price: 2.5,
                 total_price: 12.5
               }
             ]
           }
  end
end
