# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: 'sessions' }
  namespace :api do
    namespace :v1 do
      devise_for :users, controllers: {
        registrations: 'api/v1/users/registrations',
        sessions: 'api/v1/users/sessions'
      }
      get 'home', to: 'home#index'

      resources :orders do
        member do
          get 'generate_pdf' # Route to generate PDF for a specific order
        end
      end

      resources :categories do
        resources :products do
          member do
            delete 'remove_image/:attachment_id', to: 'products#remove_image', as: 'remove_image' # Route to remove a product image
          end
          collection do
            post 'prices' # Route to get product prices by IDs
          end
        end
      end

      get 'products/all', to: 'products#all_products' # Route to get all products without a category
    end
  end

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
