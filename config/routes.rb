Rails.application.routes.draw do
  get "accounts/select", to: "accounts#select", as: :accounts_selection
  get "accounts/:slug/set", to: "accounts#set", as: :set_account

  mount MissionControl::Jobs::Engine, at: "/jobs" # TODO, http_auth: { user: "test", password: "123456" }

  get "home/index"
  resource :session
  resources :passwords, param: :token
  resource :registrations, only: [ :new, :create ]
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "home#index"
end
