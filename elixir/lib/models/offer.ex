defmodule Models.Offer do
  defstruct product: nil, offer_type: nil, argument: 0

  def initialize(offer_type, product, argument) do
    %Models.Offer{offer_type: offer_type, product: product, argument: argument}
  end
end
