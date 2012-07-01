Pwf::Application.routes.draw do

  resources :seasons

  root to: "home#index"

  devise_for :parents, :controllers => { :registrations => "registrations" }

  devise_scope :parent do
    get "login", :to => "devise/sessions#new"
    get "logout", :to => "devise/sessions#destroy"
  end

  ActiveAdmin.routes(self)

  devise_for :admin_users, ActiveAdmin::Devise.config

  resources :parents

  resources :students

  resources :student_registrations do
    member do
      get :confirmation
    end
  end

  match 'dashboard' => "parents#show", :as => :parent_root


end
