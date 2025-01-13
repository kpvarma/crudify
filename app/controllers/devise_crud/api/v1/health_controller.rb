module DeviseCrud
  module Api
    module V1
      class HealthController < ApplicationController
        def health
          render json: { status: 'ok' }, status: :ok
        end
      end
    end
  end
end