class ProductsController < ApplicationController
  before_action :set_product, only: [:show]

  def index
    @categories = Category.where(is_active: true)
    @products = Product.where(is_active: true).includes(:category, images_attachments: :blob)
    
    # Search functionality
    if params[:search].present?
      @products = @products.where(
        "name ILIKE ? OR description ILIKE ?", 
        "%#{params[:search]}%", 
        "%#{params[:search]}%"
      )
    end
    
    # Category filtering
    if params[:category_id].present?
      @products = @products.where(category_id: params[:category_id])
    end
  end

  def show
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end
end
