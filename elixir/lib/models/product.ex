defmodule Models.Product do
  defstruct name: nil, unit: nil

  def initialize(name, unit) do
    %Models.Product{name: name, unit: unit}
  end
end
