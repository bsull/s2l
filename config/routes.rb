require 'subdomain'

S2l::Application.routes.draw do

  devise_for :users

  resources :users
  resources :accounts

  get "home/index"
  
  match 'sign_up' => 'users#sign_up', :as => :sign_up

  constraints(Subdomain) do
    match '/' => 'accounts#index'
  end

  root :to => "accounts#new"
end
