Rails.application.routes.draw do

  root 'homepages#index'

  resources :merchants do
    resources :products, only: [:index, :new, :create, :edit, :update]
  end

  get '/merchant/account_page', to: 'merchants#account_page', as: 'account_page_path'

  get 'merchant/order_fulfillment', to: 'merchants#order_fulfillment', as: 'order_fulfillment'

  get 'merchant/products_manager', to: 'merchants#products_manager', as: 'products_manager'

  resources :products, only: [:index, :show]

  get '/product/product_id/add_to_order', to: 'products#add_to_order', as: 'add_to_order'

  resources :orders, only: [:show, :create, :update, :destroy]

  get 'order/checkout', to: 'orders#checkout', as: 'checkout'
  patch 'order/paid', to: 'orders#paid', as: 'order_paid'

  get '/login', to: 'sessions#login_form', as: 'login'
  post '/login', to: 'sessions#login'
  delete '/logout', to: 'sessions#logout', as: 'logout'

  resources :order_products, only: [:edit, :update]


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
