module CRUDify
  class ApplicationController < ActionController::API

    # Extract and validate the Bearer token
    def authenticate_token
      authorization_header = request.headers['Authorization']
          
      if authorization_header.present? && authorization_header.start_with?('Bearer ')
        api_key = authorization_header.split('Bearer ').last.strip
      else
        render json: { error: 'API key is required in the Authorization header' }, status: :bad_request and return
      end

      # Validation logic
      if api_key.blank?
        render json: { error: 'API key is missing' }, status: :bad_request and return
      end

      api_key_record = CRUDify::ApiKey.find_by(key: api_key)

      if api_key_record.nil?
        render json: { error: 'Invalid API key' }, status: :unauthorized and return
      end

      if api_key_record.status != 'active'
        render json: { error: 'API key is not active' }, status: :forbidden and return
      end

      if api_key_record.expires_at.present? && api_key_record.expires_at < Time.current
        render json: { error: 'API key has expired' }, status: :forbidden and return
      end
    end
    
  end
end
