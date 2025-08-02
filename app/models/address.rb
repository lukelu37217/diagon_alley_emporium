class Address < ApplicationRecord
  # Associations
  belongs_to :user
  has_many :billing_orders, class_name: 'Order', foreign_key: 'billing_address_id'
  has_many :shipping_orders, class_name: 'Order', foreign_key: 'shipping_address_id'

  # Validations
  validates :address_type, presence: true, inclusion: { in: %w[billing shipping both] }
  validates :street_address, presence: true, length: { maximum: 255 }
  validates :city, presence: true, length: { maximum: 100 }
  validates :province, presence: true, length: { maximum: 100 }
  validates :postal_code, presence: true, length: { maximum: 10 }

  # Scopes
  scope :billing, -> { where(address_type: ['billing', 'both']) }
  scope :shipping, -> { where(address_type: ['shipping', 'both']) }
  scope :default, -> { where(is_default: true) }

  def full_address
    "#{street_address}, #{city}, #{province} #{postal_code}"
  end

  def can_be_billing?
    %w[billing both].include?(address_type)
  end

  def can_be_shipping?
    %w[shipping both].include?(address_type)
  end
end
