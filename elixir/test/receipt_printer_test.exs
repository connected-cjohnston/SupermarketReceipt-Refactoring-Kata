defmodule ReceiptPrinterTest do
  use ExUnit.Case
  doctest ReceiptPrinter

  test "prints a receipt with two items" do
    product = Models.Product.initialize("toothbrush", Models.ProductUnit.each())
    receipt = Models.Receipt.initialize()
    receipt = Models.Receipt.add_product(receipt, product, 1, 0.99, 0.99)
    receipt = Models.Receipt.add_product(receipt, product, 1, 0.99, 0.99)

    assert ReceiptPrinter.print_receipt(receipt) == """
           toothbrush                          0.99
           toothbrush                          0.99

           Total:                              1.98
           """
  end

  test "buy three get one free" do
    product = Models.Product.initialize("toothbrush", Models.ProductUnit.each())
    receipt = Models.Receipt.initialize()
    receipt = Models.Receipt.add_product(receipt, product, 1, 0.99, 0.99)
    receipt = Models.Receipt.add_product(receipt, product, 1, 0.99, 0.99)
    receipt = Models.Receipt.add_product(receipt, product, 1, 0.99, 0.99)

    discount = Models.Discount.initialize(product, "3 for 2", 0.99)
    receipt = Models.Receipt.add_discount(receipt, discount)

    assert ReceiptPrinter.print_receipt(receipt) == """
           toothbrush                          0.99
           toothbrush                          0.99
           toothbrush                          0.99
           3 for 2(toothbrush)                -0.99

           Total:                              1.98
           """
  end
end
