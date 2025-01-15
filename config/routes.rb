CRUDify::Engine.routes.draw do
  
  namespace :api do
    namespace :v1 do
      # The health API is what the nextjs app use for validating API urls
      get '/health', to: 'health#health'

      # The validate-api-key is what the nextjs app use for validating API keys
      post '/validate_api_key', to: 'api_keys#validate'

      # Returns all types of users configured with devise along with its attributes and other configurations
      get '/user_types', to: 'user_types#index'

      # Dynamically generate CRUD routes under /user_type_crud/:user_type
      scope '/user_type_crud/:user_type' do
        get '/', to: 'user_type_crud#index', as: 'user_type_index'
        get '/:id', to: 'user_type_crud#show', as: 'user_type_show'
        post '/', to: 'user_type_crud#create', as: 'user_type_create'
        put '/:id', to: 'user_type_crud#update', as: 'user_type_update'
        delete '/:id', to: 'user_type_crud#destroy', as: 'user_type_destroy'
      end
    end
  end

  # namespace :api do
  #   namespace :v1 do
  #     get "/test", to: "test#index"
  #   end
  # end

  # scope :api do
  #   scope :v1 do
  #     get "/:model", to: "dynamic_crud#index"
  #     get "/:model/:id", to: "dynamic_crud#show"
  #     post "/:model", to: "dynamic_crud#create"
  #     put "/:model/:id", to: "dynamic_crud#update"
  #     delete "/:model/:id", to: "dynamic_crud#destroy"
  #   end
  # end
end
  
