Rails.application.routes.draw do
  get 'order_products/edit'

  get 'order_products/update'

  get 'sessions/login'

  get 'sessions/logout'

  get 'homepages/index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
