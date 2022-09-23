Rails.application.routes.draw do
  require "sidekiq/web"

  devise_for :users, only: :omniauth_callbacks, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }

  scope "(:locale)", locale: /en|vi/ do
    authenticate :user, ->(user) { user.Admin? } do
      mount Sidekiq::Web => "/sidekiq"
    end
    root "static_pages#home"
    get "/about", to: "static_pages#about"
    get "/contact", to: "static_pages#contact"
    devise_for :users, skip: :omniauth_callbacks, controllers: {
              sessions: "users/sessions"
            }
    resources :account_activations, only: %i(edit create)
    resources :password_resets, except: %i(destroy index show)

    namespace :admin do
      get "search", to: "products#index"
      resources :static_pages
      resources :categories
      resources :orders do
        collection do
          match "search" => "orders#search", via: [:get, :post], as: :search
        end
      end
      resources :products
      resources :users
      root "static_pages#index"
    end
    resources :ratings
    resources :order_details
    resources :categories do
      member do
        get :filter
      end
    end
    resources :products
    resources :carts
    resources :orders do
      member do
        get :change
      end
    end
  end
end
