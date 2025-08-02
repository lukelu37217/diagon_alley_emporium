require 'rails_helper'

RSpec.describe Product, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      category = create(:category)
      product = Product.new(
        name: 'Magic Wand',
        description: 'A powerful magic wand',
        sku: 'MW-001',
        current_price: 29.99,
        stock_quantity: 10,
        category: category
      )
      expect(product).to be_valid
    end

    it 'is invalid without a name' do
      product = Product.new(name: nil)
      expect(product).to_not be_valid
    end

    it 'is invalid without a price' do
      product = Product.new(current_price: nil)
      expect(product).to_not be_valid
    end
  end

  describe 'associations' do
    it 'belongs to category' do
      assoc = described_class.reflect_on_association(:category)
      expect(assoc.macro).to eq :belongs_to
    end

    it 'has many order_items' do
      assoc = described_class.reflect_on_association(:order_items)
      expect(assoc.macro).to eq :has_many
    end
  end
end
