module DeviseCrud
    module Api
      module V1
        class UserTypeCrudController < ApplicationController
          before_action :authenticate_token
          before_action :set_model_class
  
          def index
            render json: @model_class.all
          end
  
          def show
            record = @model_class.find(params[:id])
            render json: record
          end
  
          def create
            record = @model_class.new(resource_params)
            if record.save
              render json: record, status: :created
            else
              render json: { errors: record.errors.full_messages }, status: :unprocessable_entity
            end
          end
  
          def update
            record = @model_class.find(params[:id])
            if record.update(resource_params)
              render json: record
            else
              render json: { errors: record.errors.full_messages }, status: :unprocessable_entity
            end
          end
  
          def destroy
            record = @model_class.find(params[:id])
            record.destroy
            head :no_content
          end
  
          private
  
          def set_model_class
            model_name = params[:user_type] # Extract user_type from URL
            if Devise.mappings.keys.map(&:to_s).include?(model_name)
              @model_class = model_name.classify.constantize
            else
              render json: { error: "Invalid user type: #{model_name}" }, status: :unprocessable_entity
            end
          end
  
          def resource_params
            params.require(@model_class.name.underscore.to_sym).permit!
          end
        end
      end
    end
  end