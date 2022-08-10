Rails.application.routes.draw do


  post 'auth/login', to: 'authentication#login'

  resources :users , only: [:create]
  resources :books do
    get 'search', to: 'books#search', on: :collection
  end
  resources :authors do
    get 'search', to: 'authors#search', on: :collection
  end

end
