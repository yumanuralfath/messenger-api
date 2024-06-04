Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  # Conversation Route and Chat
  resources :conversations do
    resources :messages, only: [:index] # Get all messages in a conversation
  end
  resources :messages, only: [:create] # Create new message in a conversation

  # User Route
  post 'auth/login', to: 'auth#login'
  post 'signup', to: 'users#create'
  resources :users, only: [:create, :show, :update, :destroy, :index]
end
