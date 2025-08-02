module Admin
  class ProductsController < ApplicationController
    before_action :authenticate_user!
    before_action :ensure_admin
    before_action :set_product, only: [:show, :edit, :update, :destroy]

    def index
      @products = Product.includes(:category).order(:name)
    end

    def show
    end

    def new
      @product = Product.new
      @categories = Category.all
    end

    def create
      @product = Product.new(product_params)
      @categories = Category.all

      if @product.save
        redirect_to admin_product_path(@product), notice: 'Product created successfully!'
      else
        render :new
      end
    end

    def edit
      @categories = Category.all
    end

    def update
      if @product.update(product_params)
        redirect_to admin_product_path(@product), notice: 'Product updated successfully!'
      else
        @categories = Category.all
        render :edit
      end
    end

    def destroy
      @product.destroy
      redirect_to admin_products_path, notice: 'Product deleted successfully!'
    end

    private

    def set_product
      @product = Product.find(params[:id])
    end

    def product_params
      params.require(:product).permit(:name, :description, :sku, :current_price, :stock_quantity, :category_id, :is_active, images: [])
    end

    def ensure_admin
      redirect_to root_path unless current_user.admin?
    end
  end
end
