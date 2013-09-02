Pwf::Application.routes.draw do

  resources :student_assessments


  resources :year_end_reports


  resources :monthly_reports


  resources :session_reports


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

  resources :parents, :path_names =>{:show => :dashboard}

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


  get 'dashboard', :to => 'dashboards#show', :path => 'dashboard'

  match 'registration_closed' => "home#closed", :as => :registration_closed

end
