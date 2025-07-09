class SubdomainStatusesController < ApplicationController
  def show
    subdomain = params[:subdomain]
    status = SubdomainStatus.where(subdomain: subdomain).where(:checked_at.gte => 24.hours.ago).first
    unless status
      result = SubdomainStatusService.check(subdomain)
      status = SubdomainStatus.create!(subdomain: subdomain, active: result[:active], http_status: result[:http_status], checked_at: Time.now)
    end
    render json: { subdomain: subdomain, active: status.active, http_status: status.http_status }
  end
end 