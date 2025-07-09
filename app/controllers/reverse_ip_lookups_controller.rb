class ReverseIpLookupsController < ApplicationController
  def show
    ip = params[:ip]
    lookup = ReverseIpLookup.where(ip_address: ip).where(:fetched_at.gte => 24.hours.ago).first
    unless lookup
      domains = ReverseIpLookupService.lookup(ip)
      if domains.present?
        lookup = ReverseIpLookup.create!(ip_address: ip, domains: domains, fetched_at: Time.now)
      end
    end
    render json: { ip: ip, domains: lookup&.domains || [] }
  end
end 