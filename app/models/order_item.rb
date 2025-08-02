class OrderItem < ApplicationRecord
  # Associations
  belongs_to :order
  belongs_to :product

  # Validations
  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validates :unit_price, :total_price, presence: true, numericality: { greater_than: 0 }
  validate :unit_price_matches_total

  # Callbacks
  before_save :calculate_total_price

  def calculate_total_price
    self.total_price = quantity * unit_price if quantity && unit_price
  end

  private

  def unit_price_matches_total
    expected_total = quantity * unit_price
    unless total_price == expected_total
      errors.add(:total_price, "must equal quantity × unit_price (#{expected_total})")
    end
  end
end
