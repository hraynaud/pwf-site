Pwf::Application.routes.draw do

  ActiveAdmin.routes(self)

  devise_for :users, :controllers => { :registrations => "registrations", :sessions => "sessions" }

  devise_for :admin_users, ActiveAdmin::Devise.config

  devise_scope :user do
    get "login", :to => "devise/sessions#new"
    get "logout", :to => "devise/sessions#destroy"
  end

  root to: "home#index"

  resources :aep_registrations

  resources :workshops

  resources :tutoring_assignments

  resources :seasons

  resources :users

  resources :parents

  resources :students

  resources :tutors

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

  #match 'dashboard' => "parents#show", 
  get '/dashboards/:id', to: 'dashboards#show', as: 'dashboard'
  match 'registration_closed' => "home#closed", :as => :registration_closed

end
