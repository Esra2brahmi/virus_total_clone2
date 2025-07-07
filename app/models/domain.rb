class Domain
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Attributes::Dynamic

  field :domain, type: String
  field :undetected_referrer_samples, type: Array
  field :whois_timestamp, type: Integer
  field :detected_downloaded_samples, type: Array
  field :detected_referrer_samples, type: Array
  field :undetected_downloaded_samples, type: Array
  field :resolutions, type: Array
  field :subdomains, type: Array
  field :categories, type: Array
  field :domain_siblings, type: Array
  field :undetected_urls, type: Array
  field :detected_urls, type: Array
  field :response_code, type: Integer
  field :verbose_msg, type: String
end 