Rails.application.routes.draw do
  namespace :admin do
    resources :numbers
    resources :notifications
    resources :items

    root to: "numbers#index"
  end

  resources :items
  resources :numbers
  post 'receive', to: 'items#create'
  #root "articles#index"
end
