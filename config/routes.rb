Rails.application.routes.draw do
  root 'posts#index'

  devise_for :users, path: 'auth', path_names: {
    sign_in: 'login',
    sign_out: 'logout',
    password: 'secret',
    confirmation: 'verification',
    unlock: 'unblock',
    registration: 'register',
    sign_up: 'signup'
  }

  resources :posts do
    resources :comments, only: [:create, :destroy]
    resources :reactions, only: [:create, :destroy]
  end
end
