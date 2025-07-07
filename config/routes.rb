Rails.application.routes.draw do
  get 'home/index'
  root "home#index"

  resources :scans, only: [:new, :create, :show]

  # IP addresses routes
  post 'ip_addresses/scan', to: 'ip_addresses#scan', as: 'ip_scan'
  post '/ip_addresses/:id/reanalyze', to: 'ip_addresses#reanalyze', as: 'reanalyze_ip', constraints: { id: /[^\/]+/ }
  get "ip_addresses/:id/relations", to: "ip_addresses#relations", as: :ip_relations
  get 'ip_addresses/show', to: 'ip_addresses#show', as: :show_ip_address

  # Domain routes
  post 'domains/scan', to: 'domains#scan', as: 'domain_scan'
  get 'domains/scan', to: 'domains#scan'
  get 'domains/communicating_files', to: 'domains#communicating_files', as: 'communicating_files'
  get 'domains/debug_api', to: 'domains#debug_api', as: 'debug_api'
  get 'domains/subdomains', to: 'domains#subdomains', as: 'subdomains'
  


end
