class ShoppingCart < ApplicationRecord
  # Associations
  belongs_to :user
  belongs_to :product

  # Validations
  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validates :user_id, uniqueness: { scope: :product_id, message: "Product already in cart" }
  validate :product_availability

  def total_price
    quantity * product.current_price
  end

  def increase_quantity(amount = 1)
    self.quantity += amount
    save
  end

  def decrease_quantity(amount = 1)
    self.quantity = [quantity - amount, 0].max
    if quantity <= 0
      destroy
    else
      save
    end
  end

  private

  def product_availability
    return unless product

    unless product.is_active?
      errors.add(:product, "is not available")
    end

    unless product.can_add_to_cart?(quantity)
      errors.add(:quantity, "exceeds available stock (#{product.stock_quantity})")
    end
  end
end
