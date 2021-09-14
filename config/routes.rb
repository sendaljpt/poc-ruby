Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  post 'register', action: :register, controller: :user
  post 'login', action: :login, controller: :user

  get 'user', action: :allUser, controller: :user
  get 'user/:id', action: :showUser, controller: :user
  put 'user/:id', action: :updateUser, controller: :user
  delete 'user/:id', action: :deleteUser, controller: :user
end
