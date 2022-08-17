Rails.application.routes.draw do

  post 'auth/login', to: 'authentication#login'

  resources :users , only: [:create, :destroy] do
    get 'book_loans', to:'book_loans#user_book_loans'
  end

  resources :books do
    get 'search', to: 'books#search', on: :collection
    get 'out_of_stock', to:'books#out_of_stock', on: :collection
  end

  resources :authors do
    get 'search', to: 'authors#search', on: :collection
  end

  resources :book_loans
end
