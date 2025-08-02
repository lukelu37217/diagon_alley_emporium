class Admin::CategoriesController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_admin
  before_action :set_category, only: [:show, :edit, :update, :destroy, :toggle_status]

  def index
    @categories = Category.includes(:products)
  end

  def show
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    
    if @category.save
      redirect_to admin_categories_path, notice: 'Category was successfully created.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @category.update(category_params)
      redirect_to admin_categories_path, notice: 'Category was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    if @category.products.any?
      redirect_to admin_categories_path, alert: 'Cannot delete category with existing products.'
    else
      @category.destroy
      redirect_to admin_categories_path, notice: 'Category was successfully deleted.'
    end
  end

  def toggle_status
    @category.update(is_active: !@category.is_active)
    redirect_to admin_categories_path, notice: "Category #{@category.is_active? ? 'activated' : 'deactivated'}."
  end

  private

  def set_category
    @category = Category.find_by(id: params[:id]) || Category.find_by(slug: params[:id]) || Category.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name, :description, :is_active)
  end

  def ensure_admin
    redirect_to root_path unless current_user.admin?
  end
end
