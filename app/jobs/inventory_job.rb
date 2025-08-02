class InventoryJob < ApplicationJob
  queue_as :default

  def perform(product_id)
    product = Product.find(product_id)
    
    # Check if stock is low
    if product.stock_quantity <= 5 && product.stock_quantity > 0
      AdminMailer.low_stock_alert(product).deliver_now
      Rails.logger.info "Low stock alert sent for #{product.name}"
    elsif product.stock_quantity == 0
      AdminMailer.out_of_stock_alert(product).deliver_now
      Rails.logger.info "Out of stock alert sent for #{product.name}"
    end
  end
end
