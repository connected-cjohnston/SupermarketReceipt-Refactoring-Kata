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
            offer.offer_type == SpecialOfferType.ten_percent_discount() ->
              Discount.initialize(
                product,
                "#{offer.argument}% off",
                quantity * unit_price * offer.argument / 100.0
              )

            offer.offer_type == SpecialOfferType.two_for_amount() && quantity >= 2 ->
              total = offer.argument * (quantity / 2) + rem(quantity, 2) * unit_price
              discount_n = unit_price * quantity - total
              Discount.initialize(product, "2 for #{offer.argument}", discount_n)

            offer.offer_type == SpecialOfferType.three_for_two() && quantity >= 2 ->
              number_of_x = quantity / quantity_amount(offer)

              discount_amount =
                quantity * unit_price -
                  (number_of_x * 2 * unit_price + rem(quantity, 3) * unit_price)

              Discount.initialize(product, "3 for 2", discount_amount)

            offer.offer_type == SpecialOfferType.five_for_amount() && quantity >= 5 ->
              number_of_x = quantity / quantity_amount(offer)

              discount_total =
                unit_price * quantity -
                  (offer.argument * number_of_x + rem(quantity, 5) * unit_price)

              Discount.initialize(
                product,
                "#{quantity_amount(offer)} for #{offer.argument}",
                discount_total
              )

            true ->
              nil
          end

        :error ->
          nil
      end

    receipt = Models.Receipt.add_discount(receipt, discount)

    handle_offer(product_quantities, receipt, offers, catalog)
  end

  defp quantity_amount(offer) do
    cond do
      offer.offer_type == SpecialOfferType.three_for_two() -> 3
      offer.offer_type == SpecialOfferType.two_for_amount() -> 2
      offer.offer_type == SpecialOfferType.five_for_amount() -> 5
      true -> 1
    end
  end
end
