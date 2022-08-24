require_relative '../spec_helper'

RSpec.describe Receipt do
  let(:product) { Product.new('example', ProductUnit::KILO) }
  subject { Receipt.new }

  it 'should return 0 when not given any items' do
    expect(subject.total_price).to eq(0)
  end

  it 'should return 5.0 when given product worth $5.00' do
    subject.add_product(product, 1, 5.00, 5.00)
  end

  it 'should return 4.50 when given product worth $5 and discount' do
    discount = Discount.new(product, 'discount', 0.5)

    subject.add_product(product, 1, 5.0, 5.0)
    subject.add_discount(discount)

    expect(subject.total_price).to eq(4.5)
  end
end
