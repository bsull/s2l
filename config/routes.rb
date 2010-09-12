require 'subdomain'

S2l::Application.routes.draw do


  devise_for :users

  resources :accounts
  resources :users
  resources :customers
  resources :confidences
  resources :opportunities

  get "home/index"
  
  match 'sign_up' => 'users#sign_up', :as => :sign_up
  match 'user_profile' => 'users#change_profile', :as => :profile
  match 'account_settings' => 'accounts#change_settings', :as => :settings
  match 'home' => 'home#index', :as => :home
  match 'my_sales2l' => 'my_sales2l#index', :as => :my_sales2l

  constraints(Subdomain) do
    match '/' => 'home#index', :as => :home
  end

  root :to => "accounts#new"
end
