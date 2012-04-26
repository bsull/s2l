require 'subdomain'

S2l::Application.routes.draw do








  devise_for :users

  match 'sign_up' => 'users#sign_up', :as => :sign_up
  match 'edit_profile' => 'users#edit_profile', :as => :profile
  match 'change_password' => 'users#change_password', :as => :password
  match 'account_settings' => 'accounts#change_settings', :as => :settings
  match 'home' => 'home#index', :as => :home
  match 'forecast' => 'forecast#index', :as => :forecast
  match 'my_sales2l' => 'my_sales2l#index', :as => :my_sales2l

  get "home/index"
  get "forecast/index"

  resources :accounts do
    resources :targets
  end
  
  resources :users do
    resources :targets
  end

  # resources :line_items
  resources :products
  resources :customers
  resources :confidences
  resources :opportunities
  resources :targets, :only => [:edit, :update, :destroy]
  
  constraints(Subdomain) do
    match '/' => 'home#index', :as => :home
  end

  root :to => "accounts#new"
end
