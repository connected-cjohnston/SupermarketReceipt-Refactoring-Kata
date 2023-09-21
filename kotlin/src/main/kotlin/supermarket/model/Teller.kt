package supermarket.model

import java.util.HashMap


class Teller(private val catalog: SupermarketCatalog) {
    private val offers = HashMap<Product, Offer>()

    fun addSpecialOffer(offerType: SpecialOfferType, product: Product, argument: Double) {
        this.offers[product] = Offer(offerType, product, argument)
    }

    fun checksOutArticlesFrom(theCart: ShoppingCart): Receipt {
        val receipt = Receipt()

        handleProducts(theCart.getItems(), receipt)
        handleOffers(receipt, this.offers, this.catalog, theCart)

        return receipt
    }

    private fun handleProducts(
        productQuantities: List<ProductQuantity>,
        receipt: Receipt
    ) {
        for (pq in productQuantities) {
            val product = pq.product
            val quantity = pq.quantity
            val unitPrice = this.catalog.getUnitPrice(product)
            val price = quantity * unitPrice
            receipt.addProduct(product, quantity, unitPrice, price)
        }
    }

    private fun handleOffers(receipt: Receipt, offers: Map<Product, Offer>, catalog: SupermarketCatalog, theCart: ShoppingCart) {
        for (product in theCart.productQuantities().keys) {
            if (!offers.containsKey(product))
                break

            val discount: Discount? = OfferHandler(product, offers, catalog, theCart.productQuantities).discount()
            if (discount != null) receipt.addDiscount(discount)
        }
    }
}
