class Category < ApplicationRecord
  # Associations
  has_many :products, dependent: :restrict_with_error
  belongs_to :parent, class_name: 'Category', optional: true
  has_many :children, class_name: 'Category', foreign_key: 'parent_id', dependent: :destroy

  # Validations
  validates :name, presence: true, length: { maximum: 100 }
  validates :slug, presence: true, uniqueness: true, length: { maximum: 100 }
  validates :description, length: { maximum: 1000 }, allow_blank: true

  # Scopes
  scope :active, -> { where(is_active: true) }
  scope :root_categories, -> { where(parent_id: nil) }

  # Callbacks
  before_validation :generate_slug, if: :name_changed?

  def to_param
    slug
  end

  def products_count
    products.active.count
  end

  private

  def generate_slug
    self.slug = name.parameterize if name.present?
  end
end
