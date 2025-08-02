require 'rails_helper'

RSpec.describe CartService, type: :service do
  let(:user) { create(:user) }
  let(:product) { create(:product, stock_quantity: 5) }
  let(:cart_service) { CartService.new(user) }

  describe '#add_item' do
    it 'adds a new item to cart' do
      expect {
        cart_service.add_item(product.id, 2)
      }.to change(user.shopping_carts, :count).by(1)
    end

    it 'updates quantity for existing item' do
      user.shopping_carts.create(product: product, quantity: 1)
      
      cart_service.add_item(product.id, 2)
      
      expect(user.shopping_carts.first.quantity).to eq(3)
    end

    it 'fails when product is out of stock' do
      out_of_stock_product = create(:product, stock_quantity: 0)
      
      result = cart_service.add_item(out_of_stock_product.id)
      
      expect(result).to be_falsey
      expect(cart_service.errors).to include("Product is out of stock")
    end
  end

  describe '#total_amount' do
    it 'calculates total correctly' do
      user.shopping_carts.create(product: product, quantity: 2)
      
      expect(cart_service.total_amount).to eq(product.price * 2)
    end
  end

  describe '#clear_cart' do
    it 'removes all items from cart' do
      user.shopping_carts.create(product: product, quantity: 2)
      
      cart_service.clear_cart
      
      expect(user.shopping_carts.count).to eq(0)
    end
  end
end
