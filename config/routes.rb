Rails.application.routes.draw do
  # Authentication routes
  resource :session, only: [:new, :create, :destroy]
  resources :passwords, param: :token, only: [:new, :create, :edit, :update]
  
  # Task routes
  resources :tasks do
    member do
      patch :complete
      patch :reschedule
    end
  end
  
  get "dashboard", to: "tasks#dashboard"
  
  root "tasks#index"
  
  # PWA routes
  get "service-worker", to: "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest", to: "rails/pwa#manifest", as: :pwa_manifest
  
  # Health check
  get "up", to: "rails/health#show", as: :rails_health_check
end