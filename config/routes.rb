Rails.application.routes.draw do
  root 'home#index' 

  mount_devise_token_auth_for 'User', at: 'auth'
  mount_devise_token_auth_for 'Admin', at: 'admin_auth'

  scope module: 'api' do
    namespace :v1 do
      resources :groups, only: [:index, :show, :create, :update, :destroy]
      resources :reports, only: [:new, :index, :show, :create, :update, :destroy]
      resources :templates, only: [:index, :show, :create, :update, :destroy]
      resources :fields, only: [:index, :show, :create, :update, :destroy]
      resources :options, only: [:show, :create, :update, :destroy]
      resources :values, only: [:show, :create, :update, :destroy]
      resources :values_statistics, only: :index
      
      as :admin do
      end
    end
  end
end
