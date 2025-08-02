class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_current_cart

  rescue_from ActiveRecord::RecordNotFound, with: :render_404
  rescue_from ActionController::RoutingError, with: :render_404

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :phone_number])
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :phone_number])
  end

  private

  def set_current_cart
    return unless user_signed_in?
    
    @current_cart_count = current_user.shopping_carts.sum(:quantity)
  end

  def render_404
    render file: "#{Rails.root}/public/404.html", status: 404, layout: false
  end
end
