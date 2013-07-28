Pwf::Application.routes.draw do



  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  devise_for :users, :controllers => { :registrations => "registrations", :sessions => "sessions" }

  devise_scope :user do
    get "login", :to => "devise/sessions#new"
    get "logout", :to => "devise/sessions#destroy"
  end

  root to: "home#index"

  resources :seasons

  resources :users

  resources :parents

  resources :students

  resources :student_registrations, :except => [:index, :show, :edit] do
    member do
      get :confirmation
    end
  end

  resources :report_cards

  resources :grades

  resources :attendances

   resources :payments, only: [:new, :index,:show, :create, :destroy] do
    collection do
      get :paypal_success
      get :paypal_cancel
      post :notify
    end
  end

  match 'dashboard' => "parents#show", :as => :user_root
  match 'registration_closed' => "home#closed", :as => :registration_closed

end
