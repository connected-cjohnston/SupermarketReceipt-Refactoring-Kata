defmodule Models.Offer do
  defstruct product: nil, offer_type: nil, argument: nil

  def initialize(offer_type, product, argument) do
    %Models.Offer{offer_type: offer_type, product: product, argument: argument}
  end
end
