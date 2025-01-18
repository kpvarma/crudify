CRUDify::Engine.routes.draw do
  
  namespace :api do
    namespace :v1 do
      # The health API is what the nextjs app use for validating API urls
      get '/health', to: 'health#health'

      # The validate-api-key is what the nextjs app use for validating API keys
      post '/validate_api_key', to: 'api_keys#validate'

      get "/metadata", to: "metadata#index"
      get "/metadata/:model_name", to: "metadata#show"

      # Dynamically generate CRUD routes under /dynamic_crud/:model_name
      scope '/dynamic_crud/:model_name' do
        get '/', to: 'dynamic_crud#index', as: 'crud_model_index'
        get '/:id', to: 'dynamic_crud#show', as: 'crud_model_show'
        post '/', to: 'dynamic_crud#create', as: 'crud_model_create'
        put '/:id', to: 'dynamic_crud#update', as: 'crud_model_update'
        delete '/:id', to: 'dynamic_crud#destroy', as: 'crud_model_destroy'

        # Route for dynamic collection actions
        put '/collections/:action_name', to: 'dynamic_crud#catch_all_collection_action', as: 'catch_all_collection_action'

        # Route for dynamic member actions
        put '/:id/:action_name', to: 'dynamic_crud#catch_all_member_action', as: 'catch_all_member_action'
      end

      # CRUDify.configuration.crudify_models.each do |model_name, config|
      #   endpoints = Array(config.get_api_end_points || [])
      #   custom_member_actions = Array(config.get_custom_member_actions.map { |action| action[:action_name] } || [])
      #   custom_collection_actions = Array(config.get_custom_collection_actions.map { |action| action[:action_name] } || [])

      #   # Rails.logger.tagged("CRUDify") do
      #     # Rails.logger.error "routes.rb endpoints: #{endpoints}"
      #     # Rails.logger.error "routes.rb custom_member_actions: #{custom_member_actions}"
      #     # Rails.logger.error "routes.rb custom_collection_actions: #{custom_collection_actions}"

      #     # Register standard RESTful routes with `only`
      #     resources model_name.to_s.underscore.pluralize, only: endpoints do
      #       # Add custom GET actions dynamically for individual resources
      #       custom_member_actions.each do |action|
      #         # Rails.logger.error "routes.rb action: #{action}"
      #         get action, on: :member # For member-level actions (applies to specific resource)
      #       end

      #       custom_collection_actions.each do |action|
      #         Rails.logger.error "routes.rb action: #{action}"
      #         get action, on: :collection # For collection actions (applies to specific resource)
      #       end
      #     end
      #   # end
        
      # end

    end
  end

end
  
