CRUDify::Engine.routes.draw do
  
  namespace :api do
    namespace :v1 do
      # The health API is what the nextjs app use for validating API urls
      get '/health', to: 'health#health'

      # The validate-api-key is what the nextjs app use for validating API keys
      post '/validate_api_key', to: 'api_keys#validate'

      get "/metadata", to: "metadata#index"
      get "/metadata/:model_name", to: "metadata#show"

      # Returns all types of users configured with devise along with its attributes and other configurations
      #get '/crud_models/devise_user_models', to: 'crud_models#devise_user_models'
      #get '/crud_models/custom_user_models', to: 'crud_models#custom_user_models'

      # Dynamically generate CRUD routes under /dynamic_crud/:crud_model
      # scope '/dynamic_crud/:crud_model' do
      #   get '/', to: 'dynamic_crud#index', as: 'crud_model_index'
      #   get '/:id', to: 'dynamic_crud#show', as: 'crud_model_show'
      #   post '/', to: 'dynamic_crud#create', as: 'crud_model_create'
      #   put '/:id', to: 'dynamic_crud#update', as: 'crud_model_update'
      #   delete '/:id', to: 'dynamic_crud#destroy', as: 'crud_model_destroy'
      # end
    end
  end

  CRUDify.configuration.crudify_models.each do |model_name, config|
    resources model_name.to_s.pluralize, only: config.actions
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
  
