module CRUDify
    module Api
      module V1
        class DynamicCrudController < ApplicationController
          
          before_action :authenticate_token
          before_action :set_model_metadata
          
          def index
            # Fetch records with associations and apply pagination
            records = scoped_collection
          
            # Map records to the desired JSON structure based on list_columns
            if @list_columns.any?
              data = records.map do |record|
                @list_columns.each_with_object({}) do |col, obj|
                  begin
                    # Check if the record responds to the column name
                    if col[:block]
                      # Use block if provided
                      val = col[:block].call(record)
                      obj[col[:name]] = val
                      
                    elsif record.respond_to?(col[:name])
                      # Use public_send if the record responds to the field name
                      obj[col[:name]] = record.public_send(col[:name])
                    else
                      # Field not found
                      obj[col[:name]] = "Error: method #{col[:name]} not found"
                    end
                  rescue StandardError => e
                    # Catch any error and set the value to a meaningful string with error details
                    obj[col[:name]] = "Error: #{e.message}"
                  end
                end
              end
            else
              data = records
            end
          
            # Total count for pagination metadata
            total_count = @model_class.count
          
            # Add metadata for pagination
            response = {
              current_page: @page,
              per_page: @per_page,
              total_pages: (total_count / @per_page.to_f).ceil,
              total_count: total_count,
              data: data
            }
          
            render json: response, status: :ok
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
            
            # Fetch model configuration
            config = CRUDify.configuration.crudify_models[@model_name]
          
            unless config
              render json: { error: "Model #{@model_name} is not configured in CRUDify" }, status: :not_found
              return
            end
          
            # Check if the action exists in custom member actions
            action = config.get_custom_member_actions.find { |a| a[:action_name] == action_name }
          
            unless action
              render json: { error: "Action #{action_name} is not defined for #{@model_name}" }, status: :unprocessable_entity
              return
            end
          
            # Dynamically execute the action logic
            instance_exec(&action[:logic])
          end

          def catch_all_collection_action
            action_name = params[:action_name].to_sym
            
            # Fetch model configuration
            config = CRUDify.configuration.crudify_models[@model_name]
          
            unless config
              render json: { error: "Model #{@model_name} is not configured in CRUDify" }, status: :not_found
              return
            end
          
            # Check if the action exists in custom collection actions
            action = config.get_custom_collection_actions.find { |a| a[:action_name] == action_name }
          
            unless action
              render json: { error: "Action #{action_name} is not defined for #{@model_name}" }, status: :unprocessable_entity
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