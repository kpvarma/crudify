module CRUDify
    class ApiKey < ApplicationRecord
      enum :status, [:active, :expired, :revoked], default: :active
  
      validates :key, presence: true, uniqueness: true
      validates :status, presence: true
      validates :expires_at, presence: true
  
      before_create :generate_key
  
      def self.generate!(expires_in_days: 30, api_key: generate_secure_key)
        create!(
          key: api_key,
          expires_at: Time.now + expires_in_days.days,
          status: :active
        )
      end
  
      private
  
      # Check if the API key is still valid
      def valid_key?
        expires_at > Time.current
      end
  
      def generate_key
        self.key ||= self.class.generate_secure_key
      end
  
      # Generate a secure API key with the required prefix
      def self.generate_secure_key
        "DEVISE-CRUD-KEY-#{SecureRandom.hex(8).upcase}" # 16-character secure hex number
      end
    end
  end