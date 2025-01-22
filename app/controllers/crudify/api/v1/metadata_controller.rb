module CRUDify
  module Api
    module V1
      class MetadataController < ApplicationController

        before_action :authenticate_token

        # Index action - Render specific metadata of all models
        def index
          
          # Get the models for which devise auth is configured
          unless defined?(Devise) && Devise.respond_to?(:mappings) && Devise.mappings.any?
            devise_models = []
          else
            devise_models = Devise.mappings.map{|x, y| y.class_name}
          end

          # Generate the models metadata
          models_metadata = CRUDify.configuration.crudify_models.map do |model_name, config|
            {
              name: model_name,
              menu: config.get_menu,
              title: config.get_title,
              description: config.get_description,
              is_devise_model: devise_models.include?(model_name)
            }
          end

          render json: models_metadata, status: :ok
        end

        # Show action - Render all metadata for a particular model
        def show
          # binding.pry
          begin
            model = params[:model_name].constantize
            unless model < ActiveRecord::Base
              render json: { error: "Invalid model #{params[:model_name]}" }, status: :unprocessable_entity
              return
            end
          rescue NameError
            render json: { error: "Model #{params[:model_name]} not found" }, status: :not_found
            return
          end
          
          model_config = CRUDify.configuration.crudify_models[model.name]

          if model_config
            render json: {
              model_name: model.name,
              title: model_config.get_title,
              description: model_config.get_description,
              menu: model_config.get_menu,
              attributes: model.attributes_metadata,
              associations: model.associations_metadata,
              
              columns: model_config.get_list_columns,
              form_fields: model_config.get_form_fields,
              scopes: format_scopes(model_config.get_record_scopes),
              filters: format_filters(model_config.get_record_filters),
              per_page: model_config.get_records_per_page,

              api_end_points: model_config.get_api_end_points,
              custom_api_end_points: model_config.get_custom_api_end_points,
            }, status: :ok
          else
            render json: { error: "Model #{model.name} not found" }, status: :not_found
          end
        end

        def devise_user_models
          unless defined?(Devise) && Devise.respond_to?(:mappings) && Devise.mappings.any?
            render json: { error: "Devise is not configured in this application." }, status: :unprocessable_entity
            return
          end
          
          # Dynamically fetch all Devise models
          devise_models = Devise.mappings.keys.map(&:to_s)

          user_types = devise_models.map do |model|
            
            # Collect Devise modules configured for the model
            devise_features = klass.devise_modules

            # Collect the Devise routes dynamically for the model
            devise_routes = fetch_devise_routes_for(model)
            #binding.pry

            {
              name: model.classify,        # e.g., "Student" or "Faculty"
              model: model,                # e.g., "students" or "Faculties"
              attributes: attributes,      # All attributes for the model
              devise_features: devise_features, # Devise features enabled for the model
              routes: devise_routes # Dynamic Devise routes configured for the model
            }
          end

          render json: user_types, status: :ok
        end

        private

        # Format scopes for consistent API response
        def format_scopes(scopes)
          scopes.map do |scope|
            {
              name: scope[:name],
              label: (scope[:options] && scope[:options][:label]) || scope[:name].to_s.titleize,
              default: (scope[:options] && scope[:options][:default]) || false
            }
          end
        end

        # Format filters for consistent API response
        def format_filters(filters)
          filters.map do |filter|
            {
              field: filter[:field],
              type: filter[:type],
              label: filter[:label] || filter[:field].to_s.titleize,
              options: filter[:options]
            }
          end
        end
      end
    end
  end
end