Rails.application.routes.draw do
  root "pages#home"
  get "about" => "pages#about"

  resources :bulk_deletion_requests, only: [:new, :create]
  resources :companies, only: [:index]

  # Healthcheck
  get "up" => "rails/health#show", :as => :rails_health_check
end
