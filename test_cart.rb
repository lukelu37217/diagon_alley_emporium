# Test script to add items to cart for testing checkout
# Run with: rails runner test_cart.rb

# Find the customer user
user = User.find_by(email: 'customer@diagonalley.com')

if user
  # Clear existing cart
  user.shopping_carts.destroy_all
  
  # Add some products to cart
  products = Product.limit(2)
  
  products.each do |product|
    user.shopping_carts.create!(
      product: product,
      quantity: 1
    )
    puts "Added #{product.name} to cart"
  end
  
  puts "Cart total: $#{user.shopping_carts.sum { |item| item.quantity * item.product.current_price }}"
else
  puts "Customer user not found!"
end
