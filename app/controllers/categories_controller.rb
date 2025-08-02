class CategoriesController < ApplicationController
  before_action :set_category, only: [:show]

  def index
    @categories = Category.includes(:products)
  end

  def show
    @products = @category.products.includes(images_attachments: :blob)
  end

  private

  def set_category
    @category = Category.find(params[:id])
  end
end
