Pwf::Application.routes.draw do

  resources :seasons

  root to: "home#index"

  devise_for :parents, :controllers => { :registrations => "registrations" }

  devise_scope :parent do
    get "login", :to => "devise/sessions#new"
    get "logout", :to => "devise/sessions#destroy"

    match '/registration_completion', :to => "registrations#complete", :as => "registration_completion"

  end

  ActiveAdmin.routes(self)

  devise_for :admin_users, ActiveAdmin::Devise.config

  resources :parents

  resources :students

  resources :student_registrations

end
