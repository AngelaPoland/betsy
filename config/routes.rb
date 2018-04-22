Rails.application.routes.draw do

  root 'products#root'

  resources :merchants, except: [:index, :create, :new, :edit, :update, :destroy] do
    resources :products, only: [:index, :new, :create, :edit, :update]
  end

  resources :categories, only: [:new, :create] do
    resources :products, only: [:index]
  end

  get '/merchants/:id/account_page', to: 'merchants#account_page', as: 'account_page'

  get 'merchants/:id/order_fulfillment', to: 'merchants#order_fulfillment', as: 'order_fulfillment'

  get 'merchants/:id/products_manager', to: 'merchants#products_manager', as: 'products_manager'

  resources :products, only: [:index, :show]

  resources :products, only: [:show] do
    resources :reviews, only: [:new]
  end

  get '/product/:id/add_to_order', to: 'products#add_to_order', as: 'add_to_order'

  resources :orders, only: [:show, :create, :update, :destroy]

  get 'orders/:id/checkout', to: 'orders#checkout', as: 'checkout'
  patch 'orders/:id/paid', to: 'orders#paid', as: 'order_paid'

  get '/auth/:provider/callback', to: 'sessions#login', as: 'auth_callback'
  get '/auth/github', as: 'github_login'
  delete '/logout', to: 'sessions#logout', as: 'logout'

  resources :order_products, only: [:edit, :update]

  patch 'merchant/:merchant_id/products/:id/active', to: 'products#active', as: 'active'

  patch 'merchant/:merchant_id/products/:id/retired', to: 'products#retire', as: 'retire'

  patch 'merchant/:merchant_id/products/:id/status', to: 'products#product_status', as: 'product_status'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
