Rails.application.routes.draw do
  devise_for :users

  root "books#index"

  resources :books do
    resources :reviews, only: [:create, :destroy]
  end

  get "/my_books", to: "books#my_books"
  get "/my_reviews", to: "reviews#my_reviews"
end