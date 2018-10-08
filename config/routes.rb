Pwf::Application.routes.draw do

  resources :groups

  ActiveAdmin.routes(self)

  devise_for :users, :controllers => { :registrations => "registrations", :sessions => "sessions" }

  devise_for :admin_users, ActiveAdmin::Devise.config

  devise_scope :user do
    get "login", :to => "devise/sessions#new"
    get "logout", :to => "devise/sessions#destroy"
  end

  root to: "home#index"

  get 'dashboard', :to => 'dashboards#show'
  get 'registration_closed' => "home#closed", :as => :registration_closed
  get 'registration_confirmation/:registration_id', to: 'student_registration_confirmations#show'

  resources :aep_registrations
  resources :aep_sessions
  resources :attendances
  resources :attendance_sheets do
   resources :attendances
  end

  resources :contact_details

  resources :users do
    resource :contact_detail
  end

  resources :grades
  resources :monthly_reports
  resources :parents do
    get :avatar, :on => :member
  end
  resources :payments, only: [:new, :index,:show, :create, :destroy] do
    collection do
      get :paypal_success
      get :paypal_cancel
      post :notify
    end
  end

  resources :report_cards do
    get :transcript, :on => :member
  end

  resources :seasons

  resources :student_registrations, :except => [:index, :show, :edit]

  resources :student_assessments
  resources :students do
    get :avatar, :on => :member
  end

  resources :image_uploads, :only => [:create]

  resources :users

end
