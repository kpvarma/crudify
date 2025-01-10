# lib/devise_crud/controllers/dynamic_crud_controller.rb
module DeviseCrud
    class DynamicCrudController < ActionController::API
      before_action :set_model
  
      def index
        render json: @model.all
      end
  
      def show
        record = @model.find(params[:id])
        render json: record
      end
  
      def create
        record = @model.new(permitted_params)
        if record.save
          render json: record, status: :created
        else
          render json: { errors: record.errors.full_messages }, status: :unprocessable_entity
        end
      end
  
      def update
        record = @model.find(params[:id])
        if record.update(permitted_params)
          render json: record
        else
          render json: { errors: record.errors.full_messages }, status: :unprocessable_entity
        end
      end
  
      def destroy
        record = @model.find(params[:id])
        record.destroy
        render json: { message: "Deleted successfully" }, status: :ok
      end
  
      private
  
      def set_model
        model_name = params[:model].classify
        @model = model_name.safe_constantize
        render json: { error: "Model not found" }, status: :not_found unless @model
      end
  
      def permitted_params
        params.require(@model.model_name.param_key).permit(@model.column_names - %w[id created_at updated_at])
      end
    end
  end