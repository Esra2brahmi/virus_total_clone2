class SubdomainStatus
  include Mongoid::Document
  include Mongoid::Timestamps

  field :subdomain, type: String
  field :active, type: Boolean
  field :http_status, type: Integer
  field :checked_at, type: Time
end 