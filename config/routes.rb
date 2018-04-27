Rails.application.routes.draw do

  root 'products#root'

  resources :merchants, except: [:index, :show, :create, :new, :edit, :update, :destroy] do
    resources :products, only: [:index, :new, :create, :edit, :update]
  end

  get '/merchant/account_page', to: 'merchants#account_page', as: 'account_page'
  get '/merchant/order_fulfillment', to: 'merchants#order_fulfillment', as: 'order_fulfillment'
  get '/merchant/products_manager', to: 'merchants#products_manager', as: 'products_manager'

  get '/merchant/about_us', to: 'merchants#about_us', as: 'about_us'

  get '/auth/failure', to: 'sessions#failure'

  resources :categories, only: [:new, :create] do
    resources :products, only: [:index]
  end

  resources :products, only: [:index, :show] do
    resources :reviews, only: [:new, :create]
  end

  get '/product/:id/add_to_order', to: 'products#add_to_order', as: 'add_to_order'

  resources :orders, only: [:show, :create, :update, :destroy] do
    resources :order_products, only: [:destroy]
  end

  get '/enter_order', to: 'orders#enter_order', as: 'enter_order'
  get '/find_order', to: 'orders#find_order'

  get '/cart', to: 'orders#index', as: 'cart'
  get '/orders/:id/checkout', to: 'orders#checkout', as: 'checkout'
  patch '/orders/:id/paid', to: 'orders#paid', as: 'order_paid'

  get '/auth/:provider/callback', to: 'sessions#login', as: 'auth_callback'
  get '/auth/github', as: 'github_login'
  delete '/logout', to: 'sessions#logout', as: 'logout'

  resources :order_products, only: [:update]

  patch '/merchant/:merchant_id/products/:id/status', to: 'products#product_status', as: 'product_status'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
