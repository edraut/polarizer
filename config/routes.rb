Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: 'welcome#show'

  ###
  # User routes
  ###

  get '/login', to: 'users#login', as: :login
  get '/signup', to: 'users#new', as: :signup
  get '/logout', to: 'users#logout', as: :logout
  post '/do_login', to: 'users#do_login', as: :do_login
  post '/create_user', to: 'users#create', as: :create_user
  delete '/remove_user', to: 'users#destroy', as: :remove_user

  ###
  # Dashboard routes
  ###

  get '/dashboard', to: 'dashboard#show', as: :dashboard
  get '/dashboard_stats', to: 'dashboard#stats', as: :dashboard_stats

  ###
  # Friendship routes
  ###
  get '/friendships', to: 'friendships#index', as: :friendships
  get '/friendships/new', to: 'friendships#new', as: :new_friendship
  post '/friendships', to: 'friendships#create', as: :create_friendship
  patch '/friendships/:id', to: 'friendships#accept', as: :accept_friendship

  ###
  # Post routes
  ###
  resources :posts do
    collection do
      get :friend
      get :my
    end
  end

  resources :comments do
    member do
      get :show_wrapper
    end
  end
end
