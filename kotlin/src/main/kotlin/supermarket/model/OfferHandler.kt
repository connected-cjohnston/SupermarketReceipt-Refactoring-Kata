package supermarket.model

class OfferHandler {
    fun handleOffer(
        product: Product,
        offers: Map<Product, Offer>,
        catalog: SupermarketCatalog,
        receipt: Receipt,
        productQuantities: MutableMap<Product, Double>
    ) {
        val quantity = productQuantities[product]!!
        val offer = offers[product]!!
        val unitPrice = catalog.getUnitPrice(product)
        val quantityAsInt = quantity.toInt()
        var discount: Discount? = null
        var quantityAmount = quantityAmount(offer)
        val numberOfXs = quantityAsInt / quantityAmount

        if (isTwoForAmount(offer, quantityAsInt)) {
            discount =
                createTwoForAmountDiscount(offer, quantityAsInt, quantityAmount, unitPrice, quantity, product)
        }
        if (isThreeForTwo(offer, quantityAsInt)) {
            discount = createThreeForAmountDiscount(quantity, unitPrice, numberOfXs, quantityAsInt, product)
        }
        if (isTenPercentDiscount(offer)) {
            discount = createTenPercentDiscount(product, offer, quantity, unitPrice)
        }
        if (isFiveForAmount(offer, quantityAsInt)) {
            discount = createFiveForAmountDiscount(
                unitPrice,
                quantity,
                offer,
                numberOfXs,
                quantityAsInt,
                product,
                quantityAmount
            )
        }


        if (discount != null)
            receipt.addDiscount(discount)
    }

    private fun quantityAmount(offer: Offer): Int {
        var quantity_amount = 1

        if (offer.offerType === SpecialOfferType.ThreeForTwo) {
            quantity_amount = 3
        } else if (offer.offerType === SpecialOfferType.TwoForAmount) {
            quantity_amount = 2
        } else if (offer.offerType === SpecialOfferType.FiveForAmount) {
            quantity_amount = 5
        }

        return quantity_amount
    }

    private fun isFiveForAmount(offer: Offer, quantityAsInt: Int) =
        offer.offerType === SpecialOfferType.FiveForAmount && quantityAsInt >= 5

    private fun isTenPercentDiscount(offer: Offer) = offer.offerType === SpecialOfferType.TenPercentDiscount

    private fun isThreeForTwo(offer: Offer, quantityAsInt: Int) =
        offer.offerType === SpecialOfferType.ThreeForTwo && quantityAsInt > 2

    private fun isTwoForAmount(offer: Offer, quantityAsInt: Int) =
        offer.offerType === SpecialOfferType.TwoForAmount && quantityAsInt >= 2

    private fun createFiveForAmountDiscount(
        unitPrice: Double,
        quantity: Double,
        offer: Offer,
        numberOfXs: Int,
        quantityAsInt: Int,
        product: Product,
        quantityAmount: Int
    ): Discount? {
        val discountTotal =
            unitPrice * quantity - (offer.argument * numberOfXs + quantityAsInt % 5 * unitPrice)
        return Discount(product, quantityAmount.toString() + " for " + offer.argument, discountTotal)
    }

    private fun createTenPercentDiscount(
        product: Product,
        offer: Offer,
        quantity: Double,
        unitPrice: Double
    ): Discount? {
        return Discount(product, offer.argument.toString() + "% off", quantity * unitPrice * offer.argument / 100.0)
    }

    private fun createThreeForAmountDiscount(
        quantity: Double,
        unitPrice: Double,
        numberOfXs: Int,
        quantityAsInt: Int,
        product: Product
    ): Discount? {
        val discountAmount =
            quantity * unitPrice - (numberOfXs.toDouble() * 2.0 * unitPrice + quantityAsInt % 3 * unitPrice)
        return Discount(product, "3 for 2", discountAmount)
    }

    private fun createTwoForAmountDiscount(
        offer: Offer,
        quantityAsInt: Int,
        quantityAmount: Int,
        unitPrice: Double,
        quantity: Double,
        product: Product
    ): Discount? {
        val total = offer.argument * (quantityAsInt / quantityAmount) + quantityAsInt % 2 * unitPrice
        val discountN = unitPrice * quantity - total
        return Discount(product, "2 for " + offer.argument, discountN)
    }
}
