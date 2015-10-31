Rails.application.routes.draw do
  root 'home#index' 

  mount_devise_token_auth_for 'User', at: 'auth', skip: [:omniauth_callbacks]
  
  resources :newsletters, only: :create
  resources :contacts, only: :create

  scope module: 'api' do
    namespace :v1 do
      resources :groups, only: [:index, :show, :create, :update, :destroy]
      resources :reports, only: [:index, :show, :create, :update, :destroy]
      resources :templates, only: [:index, :show, :create, :update, :destroy]
      resources :fields, only: [:index, :show, :create, :update, :destroy]
      resources :values, only: [:index, :show, :create, :update, :destroy]
      resources :values_statistics, only: :index
      resources :desktop_statistics, only: :index
    end
  end  
end
