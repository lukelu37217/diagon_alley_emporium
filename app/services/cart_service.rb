class CartService
  attr_reader :user, :errors

  def initialize(user)
    @user = user
    @errors = []
  end

  def add_item(product_id, quantity = 1)
    product = Product.find(product_id)
    
    unless product.in_stock?
      @errors << "Product is out of stock"
      return false
    end

    cart_item = user.shopping_carts.find_by(product: product)
    
    if cart_item
      new_quantity = cart_item.quantity + quantity.to_i
      if new_quantity <= product.stock_quantity
        cart_item.update(quantity: new_quantity)
      else
        @errors << "Not enough stock available"
        return false
      end
    else
      user.shopping_carts.create(product: product, quantity: quantity.to_i)
    end
    
    true
  rescue ActiveRecord::RecordNotFound
    @errors << "Product not found"
    false
  end

  def remove_item(cart_item_id)
    cart_item = user.shopping_carts.find(cart_item_id)
    cart_item.destroy
    true
  rescue ActiveRecord::RecordNotFound
    @errors << "Cart item not found"
    false
  end

  def update_quantity(cart_item_id, quantity)
    cart_item = user.shopping_carts.find(cart_item_id)
    
    if quantity.to_i <= 0
      cart_item.destroy
    elsif quantity.to_i <= cart_item.product.stock_quantity
      cart_item.update(quantity: quantity.to_i)
    else
      @errors << "Not enough stock available"
      return false
    end
    
    true
  rescue ActiveRecord::RecordNotFound
    @errors << "Cart item not found"
    false
  end

  def clear_cart
    user.shopping_carts.destroy_all
  end

  def total_amount
    user.shopping_carts.sum { |item| item.quantity * item.product.price }
  end

  def total_items
    user.shopping_carts.sum(:quantity)
  end
end
