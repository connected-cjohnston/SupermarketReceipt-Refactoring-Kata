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

  test "should return an empty receipt when the cart is empty", state do
    teller = Models.Teller.initialize(state[:catalog])

    receipt =
      Models.ShoppingCart.handle_offers(
        state[:cart],
        state[:receipt],
        teller.offers,
        state[:catalog]
      )

    assert receipt == %Models.Receipt{}
    assert 0.0 == Models.Receipt.total_price(receipt)
  end

  test "should return receipt with a product when there is one product and no offer", state do
    product = Models.Product.initialize("bread", :each)
    catalog = Models.SupermarketCatalog.add_product(state[:catalog], product, 2.55)
    cart = Models.ShoppingCart.add_item(state[:cart], product)
    teller = Models.Teller.initialize(state[:catalog])

    receipt = Models.ShoppingCart.handle_offers(cart, state[:receipt], teller.offers, catalog)

    assert Models.Receipt.total_price(receipt) == 2.55
  end

  test "should return receipt with two products", state do
    product1 = Models.Product.initialize("bread", :each)
    product2 = Models.Product.initialize("cheese", :each)

    catalog = Models.SupermarketCatalog.initialize()
    catalog = Models.SupermarketCatalog.add_product(catalog, product1, 2.55)
    catalog = Models.SupermarketCatalog.add_product(catalog, product2, 5.00)

    cart = Models.ShoppingCart.add_item_quantity(state[:cart], product1, 1)
    cart = Models.ShoppingCart.add_item_quantity(cart, product2, 1)

    teller = Models.Teller.initialize(state[:catalog])

    receipt = Models.ShoppingCart.handle_offers(cart, state[:receipt], teller.offers, catalog)

    assert Models.Receipt.total_price(receipt) == 7.55
  end

  test "should return receipt with 5 loaves of bread", state do
    product = Models.Product.initialize("bread", :each)
    catalog = Models.SupermarketCatalog.add_product(state[:catalog], product, 2.50)
    cart = Models.ShoppingCart.add_item_quantity(state[:cart], product, 5)
    teller = Models.Teller.initialize(state[:catalog])

    receipt = Models.ShoppingCart.handle_offers(cart, state[:receipt], teller.offers, catalog)

    assert Models.Receipt.total_price(receipt) == 12.5
  end

  test "ten percent discount", state do
    product = Models.Product.initialize("bread", :each)
    catalog = Models.SupermarketCatalog.add_product(state[:catalog], product, 10.00)
    cart = Models.ShoppingCart.add_item_quantity(state[:cart], product, 1)
    teller = Models.Teller.initialize(catalog)
    teller = Models.Teller.add_special_offer(teller, :ten_percent_discount, product, 10.00)

    receipt = Models.ShoppingCart.handle_offers(cart, state[:receipt], teller.offers, catalog)

    assert Models.Receipt.total_price(receipt) == 9.00
  end

  test "two for amount", state do
    product = Models.Product.initialize("bread", :each)
    catalog = Models.SupermarketCatalog.add_product(state[:catalog], product, 1.50)
    cart = Models.ShoppingCart.add_item_quantity(state[:cart], product, 2)
    teller = Models.Teller.initialize(catalog)
    teller = Models.Teller.add_special_offer(teller, :two_for_amount, product, 2.00)

    receipt = Models.ShoppingCart.handle_offers(cart, state[:receipt], teller.offers, catalog)

    assert Models.Receipt.total_price(receipt) == 2.0
  end
end
