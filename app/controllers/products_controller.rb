class ProductsController < ApplicationController
  before_action :set_product, only: [:show]

  def index
    @products = Product.includes(:category, image_attachment: :blob).page(params[:page])
    @categories = Category.all
  end

  def show
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end
end
