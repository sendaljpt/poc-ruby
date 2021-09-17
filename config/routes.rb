Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  # User register and login
  post 'register', action: :register, controller: :user
  post 'login', action: :login, controller: :user

  # user
  get 'user', action: :allUser, controller: :user
  get 'user/:id', action: :showUser, controller: :user
  put 'user/:id', action: :updateUser, controller: :user
  delete 'user/:id', action: :deleteUser, controller: :user

  # product
  get 'product', action: :allProduct, controller: :product
  get 'product/:id', action: :detailProduct, controller: :product

  # cart
  post 'cart', action: :addCart, controller: :cart
  get 'cart', action: :getCart, controller: :cart

  # order
  post 'order', action: :createOrder, controller: :order
end
