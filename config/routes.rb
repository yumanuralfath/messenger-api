Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :conversations, only: [:index, :show]
  # User Route
  resources :users, only: [:create, :show, :update, :destroy, :index]
end
