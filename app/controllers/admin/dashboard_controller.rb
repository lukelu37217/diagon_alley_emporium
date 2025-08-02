class Admin::DashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_admin

  def index
    @products_count = Product.count
    @categories_count = Category.count
    @orders_count = Order.count
    @users_count = User.count
    @recent_orders = Order.includes(:user).order(created_at: :desc).limit(10)
  end

  private

  def ensure_admin
    redirect_to root_path unless current_user.admin?
  end
end
