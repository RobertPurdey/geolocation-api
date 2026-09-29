# frozen_string_literal: true

class ApplicationController < ActionController::API
  private

  def authenticate
    api_key = request.headers['Authorization']&.delete_prefix('Bearer ')

    return if api_key && ActiveSupport::SecurityUtils.secure_compare(api_key, ENV.fetch('API_KEY'))

    render json: { error: 'Unauthorized. Invalid API Key.' }, status: :unauthorized
  end
end
