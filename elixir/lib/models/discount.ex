defmodule Models.Discount do
  @moduledoc """
  Represents a discount
  """
  defstruct product: nil, description: "", discount_amount: nil

  @doc """
  Returns a new Discount struct with product, description, and discount amount populated
  """
  def initialize(product, description, discount_amount) do
    %Models.Discount{product: product, description: description, discount_amount: discount_amount}
  end
end
