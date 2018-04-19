Rails.application.routes.draw do
  get 'order_products/edit'

  get 'order_products/update'

  get 'sessions/login'

  get 'sessions/logout'

  get 'homepages/index'

  get 'merchants/account_page'

  get 'merchants/order_fulfillment'

  get 'merchants/products_manager'

  get 'orders/show'

  get 'orders/create'

  get 'orders/update'

  get 'orders/checkout'

  get 'orders/paid'

  get 'orders/destroy'


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end