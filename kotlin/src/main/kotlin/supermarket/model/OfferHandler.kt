package supermarket.model

class OfferHandler(
    val product: Product,
    private val offers: Map<Product, Offer>,
    private val catalog: SupermarketCatalog,
    private val productQuantities: MutableMap<Product, Double>
) {

    fun discount(): Discount? = when {
        isTwoForAmount() -> createTwoForAmountDiscount()
        isThreeForTwo() -> createThreeForAmountDiscount()
        isTenPercentDiscount() -> createTenPercentDiscount()
        isFiveForAmount() -> createFiveForAmountDiscount()
        else -> null
    }

    private fun quantityAmount(): Int =
        when (offer().offerType) {
            SpecialOfferType.ThreeForTwo -> 3
            SpecialOfferType.TwoForAmount -> 2
            SpecialOfferType.FiveForAmount -> 5
            else -> 1
        }

    private fun quantityAsInt(): Int = quantity().toInt()

    private fun unitPrice(): Double = catalog.getUnitPrice(product)

    private fun offer(): Offer = offers[product]!!

    private fun quantity(): Double = productQuantities[product]!!

    private fun numberOfXs(): Int = quantityAsInt() / quantityAmount()

    private fun isFiveForAmount() = offer().offerType === SpecialOfferType.FiveForAmount && quantityAsInt() >= 5

    private fun isTenPercentDiscount() = offer().offerType === SpecialOfferType.TenPercentDiscount

    private fun isThreeForTwo() = offer().offerType === SpecialOfferType.ThreeForTwo && quantityAsInt() > 2

    private fun isTwoForAmount() = offer().offerType === SpecialOfferType.TwoForAmount && quantityAsInt() >= 2

    private fun createFiveForAmountDiscount(): Discount {
        val discountTotal =
            unitPrice() * quantity() - (offer().argument * numberOfXs() + quantityAsInt() % 5 * unitPrice())
        return Discount(product, quantityAmount().toString() + " for " + offer().argument, discountTotal)
    }

    private fun createTenPercentDiscount(): Discount {
        return Discount(
            product,
            offer().argument.toString() + "% off",
            quantity() * unitPrice() * offer().argument / 100.0
        )
    }

    private fun createThreeForAmountDiscount(): Discount {
        val discountAmount =
            (quantity() * unitPrice()) - ((numberOfXs().toDouble() * 2.0 * unitPrice()) + ((quantityAsInt() % 3) * unitPrice()))
        return Discount(product, "3 for 2", discountAmount)
    }

    private fun createTwoForAmountDiscount(): Discount {
        val total = offer().argument * (quantityAsInt() / quantityAmount()) + quantityAsInt() % 2 * unitPrice()
        val discountN = unitPrice() * quantity() - total
        return Discount(product, "2 for " + offer().argument, discountN)
    }
}
