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
    @total = @cart_items.sum { |item| item.quantity * item.product.current_price }
    
    # Debug logging
    Rails.logger.info "=== ORDER NEW DEBUG ==="
    Rails.logger.info "Cart items count: #{@cart_items.count}"
    @cart_items.each do |item|
      Rails.logger.info "Item: #{item.product.name}, Qty: #{item.quantity}, Price: #{item.product.current_price}"
    end
    Rails.logger.info "Total calculated: #{@total}"
    Rails.logger.info "======================="
  end

  def create
    @cart_items = current_user.shopping_carts.includes(:product)
    
    Rails.logger.info "=== ORDER CREATE DEBUG ==="
    Rails.logger.info "Params: #{params[:order]}"
    Rails.logger.info "Cart items: #{@cart_items.count}"
    Rails.logger.info "======================="
    
    if @cart_items.empty?
      redirect_to shopping_carts_path, alert: 'Your cart is empty!'
      return
    end
    
    begin
      ActiveRecord::Base.transaction do
        # Create shipping address
        shipping_address = current_user.addresses.create!(
          street_address: params[:order][:shipping_address],
          address_type: 'shipping',
          city: params[:order][:city] || 'Unknown',
          province: params[:order][:province] || 'ON',
          postal_code: params[:order][:postal_code] || 'A1A 1A1'
        )
        
        # Create billing address
        billing_address = current_user.addresses.create!(
          street_address: params[:order][:billing_address],
          address_type: 'billing',
          city: params[:order][:city] || 'Unknown',
          province: params[:order][:province] || 'ON',
          postal_code: params[:order][:postal_code] || 'A1A 1A1'
        )
        
        # Calculate taxes based on province
        subtotal = @cart_items.sum { |item| item.quantity * item.product.current_price }
        tax_data = calculate_taxes(subtotal, params[:order][:province] || 'ON')
        
        @order = current_user.orders.build(
          shipping_address: shipping_address,
          billing_address: billing_address,
          payment_method: params[:order][:payment_method],
          status: 'pending',
          subtotal: subtotal,
          gst: tax_data[:gst],
          pst: tax_data[:pst],
          hst: tax_data[:hst],
          total_amount: subtotal + tax_data[:total_tax]
        )
        
        Rails.logger.info "Order before save: #{@order.attributes}"
        Rails.logger.info "Order valid?: #{@order.valid?}"
        Rails.logger.info "Order errors: #{@order.errors.full_messages}"
        
        if @order.save
          @cart_items.each do |cart_item|
            @order.order_items.create!(
              product: cart_item.product,
              quantity: cart_item.quantity,
              price: cart_item.product.current_price
            )
          end
          
          current_user.shopping_carts.destroy_all
          redirect_to @order, notice: 'Order placed successfully!'
        else
          @total = subtotal
          render :new
        end
      end
    rescue => e
      Rails.logger.error "Order creation failed: #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
      @total = @cart_items.sum { |item| item.quantity * item.product.current_price }
      flash.now[:alert] = "Failed to create order: #{e.message}"
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
    params.require(:order).permit(:shipping_address, :billing_address, :payment_method, :province)
  end
  
  def calculate_taxes(subtotal, province)
    gst = 0
    pst = 0
    hst = 0
    
    case province.upcase
    when 'ON' # Ontario
      hst = subtotal * 0.13
    when 'BC', 'SK' # British Columbia, Saskatchewan
      gst = subtotal * 0.05
      pst = subtotal * 0.07
    when 'MB' # Manitoba
      gst = subtotal * 0.05
      pst = subtotal * 0.07
    when 'QC' # Quebec
      gst = subtotal * 0.05
      pst = subtotal * 0.09975
    when 'AB', 'NT', 'NU', 'YT' # Alberta, Northwest Territories, Nunavut, Yukon
      gst = subtotal * 0.05
    when 'NB', 'NL', 'NS', 'PE' # New Brunswick, Newfoundland, Nova Scotia, Prince Edward Island
      hst = subtotal * 0.15
    else
      gst = subtotal * 0.05 # Default GST
    end
    
    {
      gst: gst.round(2),
      pst: pst.round(2), 
      hst: hst.round(2),
      total_tax: (gst + pst + hst).round(2)
    }
  end
end
