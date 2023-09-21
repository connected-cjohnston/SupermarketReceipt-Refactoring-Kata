package supermarket.model

class OfferHandler(
    val product: Product,
    private val offers: Map<Product, Offer>,
    private val catalog: SupermarketCatalog,
    private val receipt: Receipt,
    private val productQuantities: MutableMap<Product, Double>
) {

    fun handleOffer() {
        var discount: Discount? = null

        if (isTwoForAmount()) {
            discount = createTwoForAmountDiscount()
        }
        if (isThreeForTwo()) {
            discount = createThreeForAmountDiscount()
        }
        if (isTenPercentDiscount()) {
            discount = createTenPercentDiscount()
        }
        if (isFiveForAmount()) {
            discount = createFiveForAmountDiscount()
        }


        if (discount != null)
            receipt.addDiscount(discount)
    }

    private fun quantityAsInt(): Int {
        return quantity().toInt()
    }

    private fun unitPrice(): Double {
        return catalog.getUnitPrice(product)
    }

    private fun offer(): Offer {
        return offers[product]!!
    }

    private fun quantity(): Double {
        return productQuantities[product]!!
    }

    private fun quantityAmount(): Int {
        if (offer().offerType === SpecialOfferType.ThreeForTwo) {
            return 3
        } else if (offer().offerType === SpecialOfferType.TwoForAmount) {
            return 2
        } else if (offer().offerType === SpecialOfferType.FiveForAmount) {
            return 5
        } else {
            return 1
        }
    }

    private fun isFiveForAmount() =
        offer().offerType === SpecialOfferType.FiveForAmount && quantityAsInt() >= 5

    private fun isTenPercentDiscount() = offer().offerType === SpecialOfferType.TenPercentDiscount

    private fun isThreeForTwo() =
        this.offer().offerType === SpecialOfferType.ThreeForTwo && quantityAsInt() > 2

    private fun isTwoForAmount() =
        offer().offerType === SpecialOfferType.TwoForAmount && quantityAsInt() >= 2

    private fun createFiveForAmountDiscount(): Discount? {
        val discountTotal =
            unitPrice() * quantity() - (offer().argument * numberOfXs() + quantityAsInt() % 5 * unitPrice())
        return Discount(product, quantityAmount().toString() + " for " + offer().argument, discountTotal)
    }

    private fun createTenPercentDiscount(): Discount? {
        return Discount(product, offer().argument.toString() + "% off", quantity() * unitPrice() * offer().argument / 100.0)
    }

    private fun createThreeForAmountDiscount(): Discount? {
        val discountAmount =
            (quantity() * unitPrice()) - ((numberOfXs().toDouble() * 2.0 * unitPrice()) + ((quantityAsInt() % 3) * unitPrice()))
        return Discount(product, "3 for 2", discountAmount)
    }

    private fun createTwoForAmountDiscount(): Discount? {
        val total = offer().argument * (quantityAsInt() / quantityAmount()) + quantityAsInt() % 2 * unitPrice()
        val discountN = unitPrice() * quantity() - total
        return Discount(product, "2 for " + offer().argument, discountN)
    }

    private fun numberOfXs(): Int {
        return quantityAsInt() / quantityAmount()
    }
}
