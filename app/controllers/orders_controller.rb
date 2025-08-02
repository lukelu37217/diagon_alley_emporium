class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_order, only: [:show]

  def index
    @orders = current_user.orders.order(created_at: :desc)
  end

  def show
  end

  def new
    @cart_items = current_user.shopping_carts.includes(:product)
    redirect_to shopping_carts_path, alert: 'Your cart is empty!' if @cart_items.empty?
    
    @order = Order.new
    @total = @cart_items.sum { |item| item.quantity * item.product.price }
  end

  def create
    @cart_items = current_user.shopping_carts.includes(:product)
    
    ActiveRecord::Base.transaction do
      @order = current_user.orders.build(order_params)
      @order.total_amount = @cart_items.sum { |item| item.quantity * item.product.price }
      
      if @order.save
        @cart_items.each do |cart_item|
          @order.order_items.create!(
            product: cart_item.product,
            quantity: cart_item.quantity,
            price: cart_item.product.price
          )
        end
        
        current_user.shopping_carts.destroy_all
        redirect_to @order, notice: 'Order placed successfully!'
      else
        render :new
      end
    end
  rescue ActiveRecord::RecordInvalid => e
    redirect_to new_order_path, alert: 'Failed to place order. Please try again.'
  end

  private

  def set_order
    @order = current_user.orders.find(params[:id])
  end

  def order_params
    params.require(:order).permit(:shipping_address, :billing_address, :payment_method)
  end
end
