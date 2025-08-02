class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  # Associations
  has_many :addresses, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_many :shopping_carts, dependent: :destroy
  
  # Validations
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :first_name, presence: true, length: { maximum: 100 }
  validates :last_name, presence: true, length: { maximum: 100 }
  validates :phone, length: { maximum: 15 }, format: { with: /\A[\d\-\s\+\(\)]+\z/, message: "Invalid phone format" }, allow_blank: true

  # Enum for roles
  enum role: { customer: 0, admin: 1 }

  # Instance methods
  def full_name
    "#{first_name} #{last_name}".strip
  end

  def current_cart
    shopping_carts.where(created_at: 1.day.ago..Time.current).first_or_create
  end

  # Check if user is admin
  def admin?
    role == 'admin'
  end
end
