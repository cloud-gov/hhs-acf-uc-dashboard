Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  mount JasmineRails::Engine => '/specs' if defined?(JasmineRails)

  devise_for :users

  root to: 'home#index'

  resources :dashboards, only: [:show, :index]

  namespace :admin do
    resources :users, only: [:index, :new, :create, :update]
    resources :capacities, only: [:index]
  end
end
