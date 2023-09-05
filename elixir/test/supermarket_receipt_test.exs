defmodule SupermarketReceiptTest do
  use ExUnit.Case
  doctest SupermarketReceipt

  test "greets the world" do
    assert SupermarketReceipt.hello() == :world
  end
end
