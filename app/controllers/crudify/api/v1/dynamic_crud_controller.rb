module CRUDify
    module Api
      module V1
        class DynamicCrudController < ApplicationController
          
          before_action :authenticate_token
          before_action :set_model_class
          
          def index
            render json: scoped_collection
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

          def catch_all_member_action
            action_name = params[:action_name].to_sym
            model_name = params[:model_name]
          
            # Fetch model configuration
            config = CRUDify.configuration.crudify_models[model_name]
          
            unless config
              render json: { error: "Model #{model_name} is not configured in CRUDify" }, status: :not_found
              return
            end
          
            # Check if the action exists in custom member actions
            action = config.get_custom_member_actions.find { |a| a[:action_name] == action_name }
          
            unless action
              render json: { error: "Action #{action_name} is not defined for #{model_name}" }, status: :unprocessable_entity
              return
            end
          
            # Dynamically execute the action logic
            instance_exec(&action[:logic])
          end

          def catch_all_collection_action
            action_name = params[:action_name].to_sym
            model_name = params[:model_name]
          
            # Fetch model configuration
            config = CRUDify.configuration.crudify_models[model_name]
          
            unless config
              render json: { error: "Model #{model_name} is not configured in CRUDify" }, status: :not_found
              return
            end
          
            # Check if the action exists in custom collection actions
            action = config.get_custom_collection_actions.find { |a| a[:action_name] == action_name }
          
            unless action
              render json: { error: "Action #{action_name} is not defined for #{model_name}" }, status: :unprocessable_entity
              return
            end
          
            # Dynamically execute the action logic
            instance_exec(&action[:logic])
          end

          private
  
          def set_model_class
            model_name = params[:model_name] # Extract model_name from URL
            model_config = CRUDify.configuration.crudify_models[model_name]
            
            if model_config
              @model_class = model_name.classify.constantize
            else
              render json: { error: "Invalid Model 1234: #{model_name}" }, status: :unprocessable_entity
            end
          end
  
          def resource_params
            params.require(@model_class.name.underscore.to_sym).permit!
          end

          def scoped_collection
            @model_class.all
          end

        end
      end
    end
  end