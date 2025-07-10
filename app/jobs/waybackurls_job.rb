class WaybackurlsJob < ApplicationJob
  queue_as :default

  def perform(domain_id)
    domain = Domain.find(domain_id)
    wayback_urls = WaybackurlsService.fetch(domain.domain)
    existing_urls = (domain.detected_urls || []).map { |u| u.is_a?(Hash) ? u["url"] : u }
    existing_urls += (domain.undetected_urls || []).map { |u| u.is_a?(Hash) ? u["url"] : u }
    existing_urls.uniq!

    missing_urls = wayback_urls - existing_urls

    domain.undetected_urls ||= []
    missing_urls.each do |url|
      domain.undetected_urls << url
    end
    domain.undetected_urls.uniq!
    domain.save! if missing_urls.any?
  end
end 