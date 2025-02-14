CRUDify::Engine.routes.draw do
  
  namespace :api do
    namespace :v1 do
      # The health API is what the nextjs app use for validating API urls
      get '/health', to: 'health#health'

      # The validate-api-key is what the nextjs app use for validating API keys
      post '/validate_api_key', to: 'api_keys#validate'

      get "/metadata", to: "metadata#index"
      
      # Dynamically generate CRUD routes under /dynamic_crud/:model_name
      scope '/dynamic_crud' do
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

      scope '/visualisations' do
        # Route for dynamic collection actions for collection visualisations
        get '/:action_name', to: 'visualisations#catch_all_collection_action', as: 'catch_all_collection_visualisation'

        # Route for dynamic member actions for entity visualisations
        get '/:id/:action_name', to: 'visualisations#catch_all_member_action', as: 'catch_all_member_visualisation'
      end

    end
  end

end
  
