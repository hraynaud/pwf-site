Pwf::Application.routes.draw do


   resources :payments, only: [:new, :index,:show, :create, :destroy] do
    collection do
      get :paypal_success
      get :paypal_cancel
      post :notify
    end
  end

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  devise_for :parents, :controllers => { :registrations => "registrations", :sessions => "sessions" }

  devise_scope :parent do
    get "login", :to => "devise/sessions#new"
    get "logout", :to => "devise/sessions#destroy"
  end

  root to: "home#index"

  resources :seasons

  resources :parents

  resources :students

  resources :student_registrations, :except => [:index, :show, :edit] do
    member do
      get :confirmation
    end
  end

  match 'dashboard' => "parents#show", :as => :parent_root
  match 'registration_closed' => "home#closed", :as => :registration_closed

end
