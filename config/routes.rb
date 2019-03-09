require 'sidekiq/web'
Pwf::Application.routes.draw do

  ActiveAdmin.routes(self)

  mount Sidekiq::Web => '/sidekiq'

  devise_for :users, :controllers => { :registrations => "registrations", :sessions => "sessions" }

  devise_for :admin_users, ActiveAdmin::Devise.config

  devise_scope :user do
    get "login", to:  "sessions#new"
    get "logout", to: "sessions#destroy"
    get "users", to: "sessions#new"
  end

  root to: "home#index"


  get 'dashboard', :to => 'dashboards#show'
  get 'registration_closed' => "home#closed", :as => :registration_closed
  get 'registration_confirmation/:registration_id', to: 'student_registration_confirmations#show', as: :registration_confirmation
  get 'edit_my_waitlist', to: 'parent_waitlist#edit', as: :edit_my_waitlist
  patch 'update_my_waitlist', to: 'parent_waitlist#update', as: :update_my_waitlist
  get 'waitlist_upated', to: 'parent_waitlist#thanks', as: :waitlist_updated

  resources :groups
  resources :aep_registrations
  resources :aep_sessions
  resources :attendances
  resources :attendance_sheets do
   resources :attendances
  end

  resources :contact_details

  resources :grades
  resources :monthly_reports
  resources :parents do
    resources :demographics
  end
  resources :payments, only: [:new, :index,:show, :create] do
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

  resources :student_registrations do
    get :withdraw, on: :member
  end

  resources :student_assessments
  resources :students do
    get :avatar, :on => :member
  end

  resources :image_uploads, :only => [:create]

end
