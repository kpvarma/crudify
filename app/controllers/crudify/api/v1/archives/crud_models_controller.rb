module CRUDify
  module Api
    module V1
      class CrudModelsController < ApplicationController

        before_action :authenticate_token

        def devise_user_models
          unless defined?(Devise) && Devise.respond_to?(:mappings) && Devise.mappings.any?
            render json: { error: "Devise is not configured in this application." }, status: :unprocessable_entity
            return
          end
          
          # Dynamically fetch all Devise models
          devise_models = Devise.mappings.keys.map(&:to_s)

          user_types = devise_models.map do |model|
            # Fetch the model class (e.g., Student, Faculty)
            klass = model.classify.constantize

            # Collect the attributes dynamically
            attributes = klass.column_names

            # Collect Devise modules configured for the model
            devise_features = klass.devise_modules

            # Collect the Devise routes dynamically for the model
            devise_routes = fetch_devise_routes_for(model)

            {
              name: model.classify,        # e.g., "Student" or "Faculty"
              model: model,                # e.g., "students" or "faculties"
              attributes: attributes,      # All attributes for the model
              devise_features: devise_features, # Devise features enabled for the model
              routes: devise_routes # Dynamic Devise routes configured for the model
            }
          end

          render json: user_types, status: :ok
        end

        def custom_user_models
          metadata = CRUDify.configuration.configurable_models.map do |model|
            {
              name: model.to_s,
              title: model.crudify_config[:title],
              searchable: model.crudify_config[:searchable],
              actions: model.crudify_config[:actions]
            }
          end
          render json: { models: metadata }, status: :ok
        end

        private

        def fetch_devise_routes_for(model)
          devise_scope = Devise.mappings[model.to_sym].path # e.g., "students" for Student model
          
          routes = Rails.application.routes.routes.map do |route|
            route_name = route.name
            route_path = route.path.spec.to_s
            controller = route.defaults[:controller]
            action = route.defaults[:action]
            http_method = route.verb # Get the HTTP method (GET, POST, etc.)
        
            # Check if the route belongs to Devise and matches the model's scope
            if controller&.start_with?("devise/") && 
                route_path.include?("/#{devise_scope}/") &&
                !["new", "edit"].include?(action)
              {
                name: route_name || generate_unique_name(http_method, route_path).gsub("_format", ""),
                path: route_path.gsub(/\(\.:format\)/, ""), # Remove "(:format)"
                controller: controller || "",             # Include the controller name
                action: action || "",                     # Include the action name
                http_method: http_method || ""            # Include the HTTP method
              }
            end
          end
        
          routes.compact # Remove nil entries
        end

        # Helper method to generate a unique fallback name
        def generate_unique_name(verb, path)
          "#{verb.downcase}_#{path.gsub(/[^\w]/, '_').gsub(/_+/, '_').gsub(/^_+|_+$/, '')}"
        end
      end
    end
  end
end