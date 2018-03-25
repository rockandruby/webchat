Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'users#index'
  post '/pusher/auth' => 'users#pusher_auth'
  resources :chatters, only: [:create, :show]
end
