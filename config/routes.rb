Pwf::Application.routes.draw do


  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  devise_for :parents, :controllers => { :registrations => "registrations" }

  devise_scope :parent do
    get "login", :to => "devise/sessions#new"
    get "logout", :to => "devise/sessions#destroy"
  end

  root to: "home#index"

  resources :seasons

  resources :parents

  resources :students

  resources :student_registrations do
    member do
      get :confirmation
    end
  end

  match 'dashboard' => "parents#show", :as => :parent_root
  match 'registration_closed' => "home#closed", :as => :registration_closed

end
