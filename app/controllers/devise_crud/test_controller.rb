module DeviseCrud
  module Api
    module V1
      class TestController < ApplicationController
        def index
          render json: { message: "Hello from DeviseCrud Engine" }
        end
      end
    end
  end
end