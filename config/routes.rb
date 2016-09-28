Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  mount JasmineRails::Engine => '/specs' if defined?(JasmineRails)

  devise_for :users

  root to: 'home#index'

  resources :daily_reports, only: [:show, :index]
  resources :daily_stats, only: [:create]

  namespace :admin do
    resources :users, only: [:index, :new, :create, :update]
    resources :capacities, only: [:index, :show, :update]
    resources :bed_schedules, only: [:create, :update]
  end
end
