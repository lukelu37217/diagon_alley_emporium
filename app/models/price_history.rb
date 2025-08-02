class PriceHistory < ApplicationRecord
  # Associations
  belongs_to :product

  # Validations
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :effective_from, presence: true
  validates :reason, length: { maximum: 255 }, allow_blank: true

  # Scopes
  scope :current, -> { where(effective_to: nil) }
  scope :historical, -> { where.not(effective_to: nil) }
  scope :ordered_by_date, -> { order(effective_from: :desc) }

  def current?
    effective_to.nil?
  end

  def duration
    return nil unless effective_to
    effective_to - effective_from
  end
end
