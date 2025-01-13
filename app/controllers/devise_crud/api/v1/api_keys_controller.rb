module DeviseCrud
  module Api
    module V1
      class ApiKeysController < ApplicationController

        before_action :authenticate_token

        def validate
          render json: { status: 'ok' }, status: :ok
        end
      end
    end
  end
end