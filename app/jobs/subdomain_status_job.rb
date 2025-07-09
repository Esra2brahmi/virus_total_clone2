class SubdomainStatusJob < ApplicationJob
  queue_as :default

  def perform(subdomain)
    result = SubdomainStatusService.check(subdomain)
    SubdomainStatus.create!(
      subdomain: subdomain,
      active: result[:active],
      http_status: result[:http_status],
      checked_at: Time.now
    )
  end
end 