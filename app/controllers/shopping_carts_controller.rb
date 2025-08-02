class ShoppingCartsController < ApplicationController
  before_action :authenticate_user!

  def index
    @cart_items = current_user.shopping_carts.includes(:product)
  end

  def create
    @product = Product.find(params[:product_id])
    @cart_item = current_user.shopping_carts.find_by(product: @product)
    quantity = params[:quantity].to_i

    if @cart_item
      @cart_item.quantity += quantity
      @cart_item.save
    else
      current_user.shopping_carts.create(product: @product, quantity: quantity)
    end

    redirect_to shopping_carts_path, notice: "#{@product.name} added to cart!"
  end

  def add_item
    @product = Product.find(params[:product_id])
    @cart_item = current_user.shopping_carts.find_by(product: @product)

    if @cart_item
      @cart_item.increase_quantity(1)
    else
      current_user.shopping_carts.create(product: @product, quantity: 1)
    end

    redirect_to shopping_carts_path, notice: "#{@product.name} added to cart!"
  end

  def update_item
    @cart_item = current_user.shopping_carts.find(params[:id])
    @cart_item.update(quantity: params[:quantity])
    
    redirect_to shopping_carts_path
  end

  def remove_item
    @cart_item = current_user.shopping_carts.find(params[:id])
    @cart_item.destroy
    
    redirect_to shopping_carts_path, notice: "Item removed from cart!"
  end

  def clear
    current_user.shopping_carts.destroy_all
    redirect_to shopping_carts_path, notice: "Cart cleared!"
  end
end
