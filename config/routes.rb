Allods::Application.routes.draw do
  devise_for :users, :admin

  resources :home,   :only => :index
  resources :admins, :only => :index
  namespace :admin do
    resources :users, only: [:new, :create]
  end

  resources :personnages, :controller => :characters, :as => :characters
  resources :groupes, :controller => :loot_machines, :as => :loot_machines

  root :to => 'home#index'
end
