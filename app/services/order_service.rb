class OrderService
  attr_reader :user, :errors

  def initialize(user)
    @user = user
    @errors = []
  end

  def create_order(order_params)
    cart_items = user.shopping_carts.includes(:product)
    
    if cart_items.empty?
      @errors << "Cart is empty"
      return nil
    end

    # Check stock availability
    cart_items.each do |item|
      unless item.product.in_stock? && item.quantity <= item.product.stock_quantity
        @errors << "#{item.product.name} is not available in requested quantity"
      end
    end

    return nil if @errors.any?

    ActiveRecord::Base.transaction do
      order = user.orders.create!(
        total_amount: calculate_total(cart_items),
        shipping_address: order_params[:shipping_address],
        billing_address: order_params[:billing_address],
        payment_method: order_params[:payment_method],
        status: 'pending'
      )

      # Create order items and update stock
      cart_items.each do |cart_item|
        order.order_items.create!(
          product: cart_item.product,
          quantity: cart_item.quantity,
          price: cart_item.product.price
        )
        
        cart_item.product.decrease_stock!(cart_item.quantity)
      end

      # Clear cart
      user.shopping_carts.destroy_all

      # Send confirmation email
      OrderMailer.order_confirmation(order).deliver_later

      order
    end
  rescue ActiveRecord::RecordInvalid => e
    @errors << e.message
    nil
  end

  def update_order_status(order, new_status)
    order.update!(status: new_status)
    
    case new_status
    when 'shipped'
      OrderMailer.order_shipped(order).deliver_later
    when 'delivered'
      OrderMailer.order_delivered(order).deliver_later
    end
    
    true
  rescue ActiveRecord::RecordInvalid => e
    @errors << e.message
    false
  end

  private

  def calculate_total(cart_items)
    cart_items.sum { |item| item.quantity * item.product.price }
  end
end
