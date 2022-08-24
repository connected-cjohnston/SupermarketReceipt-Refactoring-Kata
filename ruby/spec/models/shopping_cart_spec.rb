require_relative '../spec_helper'

RSpec.describe ShoppingCart do

  it 'should work' do
    receipt = Receipt.new
    offers = {}
    catalog = FakeCatalog.new
    cart = ShoppingCart.new

    cart.handle_offers(receipt, offers, catalog)
  end

  describe 'three for two' do
    it 'should correctly calculate 3 for 2 discount offer' do
      cart = ShoppingCart.new
      receipt = Receipt.new
      product = Product.new
      offer = Offer.new(SpecialOfferType::THREE_FOR_TWO, product, "")
      offers = { product => offer }
      catalog = FakeCatalog.new

      cart.handle_offers(receipt, offers, catalog)

      expect(receipt.discounts).to eq(nil)
    end
  end
end
