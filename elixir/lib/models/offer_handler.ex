defmodule Models.OfferHandler do
  alias Models.Discount
  alias Models.SpecialOfferType

  def handle_offer([], receipt, _offers, _catalog), do: receipt

  def handle_offer([pq | product_quantities], receipt, offers, catalog) do
    product = pq.product
    quantity = pq.quantity
    unit_price = Models.SupermarketCatalog.unit_price(catalog, product)

    discount =
      case Map.fetch(offers, product) do
        {:ok, offer} ->
          cond do
            offer.offer_type == SpecialOfferType.two_for_amount() && quantity >= 2 ->
              Discount.two_for_amount_discount(quantity, offer, unit_price, product)

            offer.offer_type == SpecialOfferType.three_for_two() && quantity >= 2 ->
              Discount.three_for_two_discount(quantity, offer, unit_price, product)

            offer.offer_type == SpecialOfferType.five_for_amount() && quantity >= 5 ->
              Discount.five_for_amount_discount(quantity, offer, unit_price, product)

            offer.offer_type == SpecialOfferType.ten_percent_discount() ->
              Discount.ten_percent_discount(quantity, offer, unit_price, product)

            true ->
              nil
          end

        :error ->
          nil
      end

    receipt = Models.Receipt.add_discount(receipt, discount)

    handle_offer(product_quantities, receipt, offers, catalog)
  end
end
