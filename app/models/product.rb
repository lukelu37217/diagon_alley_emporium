class Product < ApplicationRecord
  # Associations
  belongs_to :category
  has_many :price_histories, dependent: :destroy
  has_many :order_items, dependent: :restrict_with_error
  has_many :shopping_carts, dependent: :destroy
  has_many_attached :images
  
  # Validations
  validates :name, presence: true, length: { maximum: 255 }
  validates :description, presence: true, length: { maximum: 2000 }
  validates :sku, presence: true, uniqueness: true, format: { with: /\A[A-Z0-9\-]+\z/ }
  validates :current_price, presence: true, numericality: { greater_than: 0 }
  validates :stock_quantity, presence: true, numericality: { greater_than_or_equal_to: 0 }
  
  # Scopes
  scope :active, -> { where(is_active: true) }
  scope :in_stock, -> { where('stock_quantity > 0') }
  scope :by_category, ->(category_id) { where(category_id: category_id) }
  scope :search_by_name, ->(term) { where('name ILIKE ?', "%#{term}%") }
  scope :search_by_description, ->(term) { where('description ILIKE ?', "%#{term}%") }
  
  # Callbacks
  before_create :create_initial_price_history
  before_update :create_price_history_if_price_changed
  
  # Instance methods
  def price
    current_price
  end

  def image
    images.first
  end

  def in_stock?
    stock_quantity > 0
  end

  def decrease_stock!(quantity)
    update!(stock_quantity: stock_quantity - quantity)
  end

  def featured?
    false # This can be implemented with a featured column later
  end

  def display_price
    "$#{price.to_f}"
  end
  
  def can_add_to_cart?(quantity = 1)
    in_stock? && stock_quantity >= quantity
  end
  
  def main_image
    images.attached? ? images.first : nil
  end
  
  private
  
  def create_initial_price_history
    price_histories.build(
      price: current_price,
      effective_from: Time.current,
      reason: 'Initial price'
    )
  end
  
  def create_price_history_if_price_changed
    if current_price_changed? && persisted?
      # End current price history
      current_history = price_histories.where(effective_to: nil).first
      current_history&.update(effective_to: Time.current)
      
      # Create new price history
      price_histories.build(
        price: current_price,
        effective_from: Time.current,
        reason: 'Price update'
      )
    end
  end
end
