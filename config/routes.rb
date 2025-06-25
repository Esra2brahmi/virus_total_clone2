Rails.application.routes.draw do
  root "scans#new"
  resources :scans, only: [:new, :create, :show]
end
