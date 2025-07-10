class SubdomainStatus
  include Mongoid::Document
  include Mongoid::Timestamps

  field :subdomain, type: String
  field :active, type: Boolean
  field :http_status, type: String
  field :checked_at, type: Time
  field :url, type: String
  field :content_length, type: String
  field :title, type: String
  field :web_server, type: String
  field :technologies, type: Array
  field :error, type: String
end 