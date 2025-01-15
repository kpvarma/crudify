Rails.application.routes.draw do
  mount CRUDify::Engine => "/crudify"
end
