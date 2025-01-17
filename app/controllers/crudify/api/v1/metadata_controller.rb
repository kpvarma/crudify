module CRUDify
  module Api
    module V1
      class MetadataController < ApplicationController

        before_action :authenticate_token

        # Index action - Render specific metadata of all models
        def index
          models_metadata = CRUDify.configuration.crudify_models.map do |model_name, config|
            {
              type: "crudify_model",
              model_name: model_name,
              menu: config.get_menu,
              title: config.get_title
            }
          end
          
          unless defined?(Devise) && Devise.respond_to?(:mappings) && Devise.mappings.any?
            devise_models = []
          else
            devise_models = Devise.mappings.map{|x, y| y.class_name}
          end

          user_models_metadata = CRUDify.configuration.crudify_user_models.map do |model_name, config|
            {
              type: "crudify_user_model",
              model_name: model_name,
              devise_model: devise_models.include?(model_name),
              menu: config.get_menu, 
              title: config.get_title
            }
          end

          render json: {
            crudify_models: models_metadata,
            crudify_user_models: user_models_metadata
          }, status: :ok
        end

        # Show action - Render all metadata for a particular model
        def show
          #binding.pry
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
          
          model_config = CRUDify.configuration.crudify_models[model.name] || CRUDify.configuration.crudify_user_models[model.name]

          if model_config
            render json: {
              type: model_config.is_a?(CRUDify::UserModelConfig) ? "crudify_user_model" : "crudify_model",
              model_name: model.name,
              title: model_config.get_title,
              menu: model_config.get_menu,
              attributes: model.attributes_metadata,
              associations: model.associations_metadata,
              list_columns: model_config.get_list_columns,
              form_columns: model_config.get_form_columns,
              #actions: model_config.get_actions,
              #per_page: model_config.get_per_page,
              #scopes: format_scopes(model_config.get_scopes),
              #filters: format_filters(model_config.get_filters),
              #custom_options: model_config.respond_to?(:get_custom_options) ? model_config.get_custom_options : nil
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
              name: model.classify,        # e.g., "Student" or "Teacher"
              model: model,                # e.g., "students" or "teachers"
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

              # Collect the attributes dynamically
              # attributes = klass.column_names

              default: scope[:default] || false,
              description: scope[:description],
              scope: scope[:scope].is_a?(Proc) ? "dynamic_scope" : scope[:scope]
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