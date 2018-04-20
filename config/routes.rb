Rails.application.routes.draw do

  root 'products#root'

  resources :merchants, except: [:index, :create, :new, :edit, :update, :destroy] do
    resources :products, only: [:index, :new, :create, :edit, :update]
  end

  get '/merchants/:id/account_page', to: 'merchants#account_page', as: 'account_page_path'

  get 'merchants/:id/order_fulfillment', to: 'merchants#order_fulfillment', as: 'order_fulfillment'

  get 'merchants/:id/products_manager', to: 'merchants#products_manager', as: 'products_manager'

  resources :products, only: [:index, :show]

  get '/product/product_id/add_to_order', to: 'products#add_to_order', as: 'add_to_order'

  resources :orders, only: [:show, :create, :update, :destroy]

  get 'orders/:id/checkout', to: 'orders#checkout', as: 'checkout'
  patch 'orders/:id/paid', to: 'orders#paid', as: 'order_paid'

  get '/auth/:provider/callback', to: 'sessions#login', as: 'auth_callback'
  get '/auth/github', as: 'github_login'
  delete '/logout', to: 'sessions#logout', as: 'logout'

  resources :order_products, only: [:edit, :update]


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
