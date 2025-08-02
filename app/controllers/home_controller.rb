class HomeController < ApplicationController
  def index
    @featured_products = Product.where(is_active: true)
                               .includes(:category)
                               .limit(8)
                               .order(created_at: :desc)
    @categories = Category.where(is_active: true).limit(6)
  end
end
