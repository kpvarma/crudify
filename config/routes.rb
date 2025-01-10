DeviseCrud::Engine.routes.draw do
    namespace :api do
      namespace :v1 do
        get "/test", to: "test#index"
      end
    end
    scope :api do
      scope :v1 do
        get "/:model", to: "dynamic_crud#index"
        get "/:model/:id", to: "dynamic_crud#show"
        post "/:model", to: "dynamic_crud#create"
        put "/:model/:id", to: "dynamic_crud#update"
        delete "/:model/:id", to: "dynamic_crud#destroy"
      end
    end
  end
  
