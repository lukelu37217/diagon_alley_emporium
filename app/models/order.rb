class Order < ApplicationRecord
  # Associations
  belongs_to :user
  belongs_to :billing_address, class_name: 'Address', optional: true
  belongs_to :shipping_address, class_name: 'Address', optional: true
  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items

  # Validations
  validates :order_number, presence: true, uniqueness: true
  validates :status, presence: true, inclusion: { in: %w[pending confirmed processing shipped delivered cancelled] }
  validates :subtotal, :total_amount, presence: true, numericality: { greater_than_or_equal_to: 0 }

  # Enums
  enum status: {
    pending: 'pending',
    confirmed: 'confirmed',
    processing: 'processing',
    shipped: 'shipped',
    delivered: 'delivered',
    cancelled: 'cancelled'
  }

  # Scopes
  scope :recent, -> { order(created_at: :desc) }
  scope :completed, -> { where(status: ['delivered', 'shipped']) }

  # Callbacks
  before_create :generate_order_number, if: -> { order_number.blank? }

  def total_items
    order_items.sum(:quantity)
  end

  def tax_amount
    total_amount - subtotal
  end

  def can_be_cancelled?
    %w[pending confirmed].include?(status)
  end

  def completed?
    %w[delivered shipped].include?(status)
  end

  private

  def generate_order_number
    self.order_number = "DA#{Time.current.strftime('%Y%m%d')}#{SecureRandom.hex(4).upcase}"
  end
end
