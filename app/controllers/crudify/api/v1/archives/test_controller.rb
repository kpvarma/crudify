module CRUDify
  module Api
    module V1
      class TestController < ApplicationController
        def index
          render json: { message: "Hello from CRUDify Engine" }
        end
      end
    end
  end
end