module CRUDify
    module Api
      module V1
        class VisualisationsController < ApplicationController
          
          before_action :authenticate_token
          before_action :set_model_metadata
          
          def catch_all_collection_action
            action_name = params[:action_name].to_sym
            
            # Fetch model configuration
            config = CRUDify.configuration.crudify_visuals[@model_name]
          
            unless config
              render json: { error: "Visualisation for the Model  #{@model_name} is not configured in CRUDify" }, status: :not_found
              return
            end
          
            # Check if the action exists in custom collection actions
            action = config.collection_end_points.find { |a| a[:name] == action_name }

            unless action
              render json: { error: "End Point #{action_name} is not defined for #{@model_name} Visualisation" }, status: :unprocessable_entity
              return
            end
          
            # Dynamically execute the action logic
            instance_exec(&action[:logic])
          end

          def catch_all_member_action
            action_name = params[:action_name].to_sym
            
            # Fetch model configuration
            config = CRUDify.configuration.crudify_visuals[@model_name]
          
            unless config
              render json: { error: "Visualisation for the Model #{@model_name} is not configured in CRUDify" }, status: :not_found
              return
            end
          
            # Check if the action exists in custom member actions
            action = config.entity_end_points.find { |a| a[:action_name] == action_name }
          
            unless action
              render json: { error: "End Point #{action_name} is not defined for #{@model_name} Visualisation" }, status: :unprocessable_entity
              return
            end
          
            # Dynamically execute the action logic
            instance_exec(&action[:logic])
          end

          private
  
          def set_model_metadata
            @model_name = params[:model_name] # Extract model_name from URL
            unless @model_name
              render json: { error: "Crudify not configured for the model: #{params[:model_name]}" }, status: :unprocessable_entity
              return
            end
            
            @model_config = CRUDify.configuration.crudify_models[@model_name]
            unless @model_config
              render json: { error: "Crudify not configured for the model: #{params[:model_name]}" }, status: :unprocessable_entity
              return
            end

            @model_class = @model_name.classify.constantize
          end
  
          def resource_params
            params.require(@model_class.name.underscore.to_sym).permit!
          end

          def scoped_collection
            # Get list columns and associations to include
            @list_columns = @model_config.get_list_columns
            @association_includes = @list_columns.map { |col| col[:options][:include] }.compact

            unless @list_columns
              render json: { error: "Crudify not configured for the model: #{@model_class.name}" }, status: :unprocessable_entity
              return
            end
          
            # Fetch pagination parameters
            @page = params[:page].to_i > 0 ? params[:page].to_i : 1
            @per_page = params[:per_page].to_i > 0 ? params[:per_page].to_i : @model_config.get_records_per_page.first
          
            # Calculate offset
            @offset = (@page - 1) * @per_page
          
            # Fetch records with associations and apply pagination
            relation = @model_class.all
            relation = relation.includes(*@association_includes) if @association_includes.any?
            relation = relation.offset(@offset).limit(@per_page)
          end

        end
      end
    end
  end