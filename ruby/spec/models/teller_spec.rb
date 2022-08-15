require_relative '../spec_helper'

RSpec.describe Teller do
  it 'should return a new receipt when given an empty cart' do
    catalog = FakeCatalog.new
    cart = ShoppingCart.new
    teller = Teller.new(catalog)

    receipt = teller.checks_out_articles_from(cart)

    expect(receipt.items).to eq([])
    expect(receipt.discounts).to eq([])
  end
end
