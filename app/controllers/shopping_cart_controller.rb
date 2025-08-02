class ShoppingCartController < ApplicationController
  before_action :authenticate_user!
  before_action :set_cart_item, only: [:update, :destroy]

  def index
    @cart_items = current_user.shopping_carts.includes(:product)
    @total = @cart_items.sum { |item| item.quantity * item.product.price }
  end

  def create
    @product = Product.find(params[:product_id])
    @cart_item = current_user.shopping_carts.find_by(product: @product)
    
    if @cart_item
      @cart_item.quantity += params[:quantity].to_i
    else
      @cart_item = current_user.shopping_carts.build(
        product: @product,
        quantity: params[:quantity].to_i
      )
    end
    
    if @cart_item.save
      redirect_to shopping_cart_index_path, notice: 'Item added to cart successfully!'
    else
      redirect_to @product, alert: 'Failed to add item to cart.'
    end
  end

  def update
    if @cart_item.update(quantity: params[:quantity])
      redirect_to shopping_cart_index_path, notice: 'Cart updated successfully!'
    else
      redirect_to shopping_cart_index_path, alert: 'Failed to update cart.'
    end
  end

  def destroy
    @cart_item.destroy
    redirect_to shopping_cart_index_path, notice: 'Item removed from cart!'
  end

  private

  def set_cart_item
    @cart_item = current_user.shopping_carts.find(params[:id])
  end
end
