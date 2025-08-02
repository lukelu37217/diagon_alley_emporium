class ProductSearch
  attr_reader :products, :query, :category, :sort_by

  def initialize(params = {})
    @query = params[:q]
    @category = params[:category_id]
    @sort_by = params[:sort_by] || 'name'
    @products = search_products
  end

  private

  def search_products
    scope = Product.includes(:category, images_attachments: :blob)
    
    scope = scope.search_by_name(@query) if @query.present?
    scope = scope.by_category(@category) if @category.present?
    scope = apply_sorting(scope)
    
    scope
  end

  def apply_sorting(scope)
    case @sort_by
    when 'price_low'
      scope.order(:current_price)
    when 'price_high'
      scope.order(current_price: :desc)
    when 'newest'
      scope.order(created_at: :desc)
    else
      scope.order(:name)
    end
  end
end
