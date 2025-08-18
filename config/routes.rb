Rails.application.routes.draw do
  resources :loan_repayments
  get '/members/:id/available_for_loans', to: 'members#available_for_loans'
  resources :loans

  resources :savings do
  collection do
    post :create_monthly
  end
  end

  resources :members do
  member do
    patch :toggle_status
  end
  end

  get "members/:member_id/statement", to: "members#statement", as: :member_statement

  resources :members do
    get :statement, on: :member
  end

  resources :members do
  member do
    get :id_card
  end
  end
  
  devise_for :users, controllers: {
  registrations: "users/registrations"
  }

  resources :users do
    member do
      patch :toggle_access
    end
  end

   resources :users do
    member do
      patch :toggle_status
    end
  end

  post "/toggle_sign_ups", to: "settings#toggle_sign_ups", as: "toggle_sign_ups"

  
  resources :advances

  resources :employees do
  member do
    patch :toggle_status
  end
  end
  
  root "members#index"
  get "home/index"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  # "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
