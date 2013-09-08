Pwf::Application.routes.draw do


  namespace :mgr do
    resources :aep_attendances
  end


  ActiveAdmin.routes(self)

  devise_for :users, :controllers => { :registrations => "registrations", :sessions => "sessions" }

  devise_for :admin_users, ActiveAdmin::Devise.config

  devise_scope :user do
    get "login", :to => "devise/sessions#new"
    get "logout", :to => "devise/sessions#destroy"
  end

  root to: "home#index"

  get 'dashboard', :to => 'dashboards#show', :path => 'dashboard'

  match 'registration_closed' => "home#closed", :as => :registration_closed

  resources :aep_registrations
  resources :aep_sessions
  resources :attendances
  resources :grades
  resources :monthly_reports
  resources :parents

  resources :payments, only: [:new, :index,:show, :create, :destroy] do
    collection do
      get :paypal_success
      get :paypal_cancel
      post :notify
    end
  end

  resources :report_cards
  resources :seasons
  resources :session_reports

  resources :student_registrations, :except => [:index, :show, :edit] do
    member do
      get :confirmation
    end
  end

  resources :student_assessments
  resources :students
  resources :tutoring_assignments
  resources :tutors
  resources :users
  resources :workshops
  resources :workshop_enrollments
  resources :year_end_reports

  #-----------------------------
  #Namespaced and nested routes

  namespace :mgr do
    resources :aep_registrations
    resources :aep_sessions
    resources :attendances
    resources :grades
    resources :monthly_reports
    resources :parents
    resources :tutoring_assignments
    resources :tutors
    resources :workshops
    resources :workshop_enrollments
    resources :year_end_reports

  end


end
