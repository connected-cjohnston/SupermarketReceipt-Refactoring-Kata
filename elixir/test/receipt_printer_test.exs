defmodule ReceiptPrinterTest do
  use ExUnit.Case
  doctest ReceiptPrinter

  test "is true" do
    assert ReceiptPrinter.print_receipt() == true
  end
end
