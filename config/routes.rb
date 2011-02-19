Allods::Application.routes.draw do
  devise_for :users, :admin

  resources :home,   :only => :index
  resources :admins, :only => :index

  resources :characters
  resources :loot_machines

  root :to => 'home#index'
end
