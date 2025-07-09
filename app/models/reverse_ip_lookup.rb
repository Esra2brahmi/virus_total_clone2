class ReverseIpLookup
  include Mongoid::Document
  include Mongoid::Timestamps

  field :ip_address, type: String
  field :domains, type: Array
  field :fetched_at, type: Time
end 