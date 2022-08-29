require_relative '../spec_helper'

RSpec.describe ShoppingCart do
  let(:product) { Product.new('KD', ProductUnit::EACH) }

  describe 'add item' do
    subject { ShoppingCart.new }

    it 'should add a product with a default quantity of 1' do
      subject.add_item(product)

      product_quantity = subject.items.first
      expect(product_quantity.product).to eq(product)
      expect(product_quantity.quantity).to eq(1)
    end

    it 'should add a product with a given quantity' do
      subject.add_item_quantity(product, 2)

      product_quantity = subject.items.first
      expect(product_quantity.product).to eq(product)
      expect(product_quantity.quantity).to eq(2)
    end

    it 'should increase the quantity of a product when adding the product twice' do
      subject.add_item_quantity(product, 2)
      subject.add_item_quantity(product, 3)

      expect(subject.product_quantities[product]).to eq(5)
    end
  end

  describe 'three for two' do
    it 'should correctly calculate 3 for 2 discount offer' do
      catalog = FakeCatalog.new
      catalog.add_product(product, 5.00)

      offer = Offer.new(SpecialOfferType::THREE_FOR_TWO, product, "")
      offers = { product => offer }

      receipt = Receipt.new
      discount = Discount.new(product, '3 for 2', 5.0)

      subject.add_item_quantity(product, 3)
      subject.handle_offers(receipt, offers, catalog)

      expect(receipt.discounts).to eq([discount])
      expect(receipt.total_price).to eq(10.0)
    end
  end
end
