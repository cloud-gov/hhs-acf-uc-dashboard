Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'home#index'
  get '/dashboard_authorization', to: 'dashboard_authorization#index', as: :dashboard_authorization

  namespace :admin do
    resources :users, only: [:index, :update]
  end
end
