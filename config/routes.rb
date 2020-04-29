Rails.application.routes.draw do

  root 'static_pages#home'
  get '/help', to: 'static_pages#help'
  get '/contact', to: 'static_pages#contact'
  get '/signup', to: 'users#new'
  post '/signup', to: 'users#create'
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  resources :users
  resources :facilities, only: [:show, :edit, :new, :create, :update, :destroy] do
    resources :posts, only: [:index, :show, :new, :create, :edit, :update, :destroy]
    resources :kids, only: [:show, :new, :create, :edit, :update, :destroy] do
      resources :back_from_schools, only: [:create]
      resources :finish_homeworks, only: [:create]
    end

  end

end
