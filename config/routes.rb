Rails.application.routes.draw do
  devise_for :users
  # Root route
  root 'home#index'
  
  # Public routes
  get 'home/index'
  resources :products, only: [:index, :show]
  resources :categories, only: [:index, :show]
  
  # Shopping cart routes
  resources :shopping_carts, except: [:show, :new, :edit] do
    member do
      patch :update_item
      delete :remove_item
    end
    collection do
      post :add_item
      delete :clear
    end
  end
  
  # Order routes (requires authentication)
  resources :orders, only: [:index, :show, :new, :create]
  
  # Admin routes
  namespace :admin do
    root 'dashboard#index'
    get 'dashboard', to: 'dashboard#index'
    
    resources :products do
      member do
        patch :toggle_status
      end
    end
    
    resources :categories do
      member do
        patch :toggle_status
      end
    end
    
    resources :orders, only: [:index, :show, :edit, :update]
    resources :users, only: [:index, :show, :edit, :update]
  end
  
  # Health check route
  get "up" => "rails/health#show", as: :rails_health_check
end
