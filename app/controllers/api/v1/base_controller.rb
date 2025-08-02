# API for handling AJAX requests
class Api::V1::BaseController < ApplicationController
  skip_before_action :verify_authenticity_token
  respond_to :json

  protected

  def render_success(data = {}, message = 'Success')
    render json: {
      status: 'success',
      message: message,
      data: data
    }
  end

  def render_error(message = 'Error', errors = {})
    render json: {
      status: 'error',
      message: message,
      errors: errors
    }
  end
end
