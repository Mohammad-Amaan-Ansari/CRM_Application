# frozen_string_literal: true

Rails.application.routes.draw do
  # get "up" => "rails/health#show", as: :rails_health_check
  devise_for :users

  root to: 'home#index'
  get 'all_products', to: 'products#all_products', as: 'all_products'
  post 'products/prices', to: 'products#prices'
  resources :customers, only: %i[new create index]

  resources :categories do
    resources :products
  end
  resources :products do
    resources :orders
  end

  # Add a route to access all products

  resources :orders do
    member do
      get 'generate_pdf'
    end
  end

  resources :products do
    member do
      delete :remove_image
    end
  end
end
