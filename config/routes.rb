Rails.application.routes.draw do
  resources :rota_assignments, only: [:index] do
    post :create_for_dates, on: :collection
  end
end
