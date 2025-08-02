class ShoppingCartsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_cart

  def index
    @cart_items = @cart.shopping_cart_items.includes(:product)
  end

  def add_item
    @product = Product.find(params[:product_id])
    @cart_item = @cart.shopping_cart_items.find_by(product: @product)

    if @cart_item
      @cart_item.quantity += 1
      @cart_item.save
    else
      @cart.shopping_cart_items.create(product: @product, quantity: 1)
    end

    redirect_to shopping_carts_path, notice: "#{@product.name} added to cart!"
  end

  def update_item
    @cart_item = @cart.shopping_cart_items.find(params[:id])
    @cart_item.update(quantity: params[:quantity])
    
    redirect_to shopping_carts_path
  end

  def remove_item
    @cart_item = @cart.shopping_cart_items.find(params[:id])
    @cart_item.destroy
    
    redirect_to shopping_carts_path, notice: "Item removed from cart!"
  end

  def clear
    @cart.shopping_cart_items.destroy_all
    redirect_to shopping_carts_path, notice: "Cart cleared!"
  end

  private

  def set_cart
    @cart = current_user.shopping_cart || current_user.create_shopping_cart
  end
end
