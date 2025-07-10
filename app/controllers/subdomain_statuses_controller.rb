class SubdomainStatusesController < ApplicationController
  def show
    subdomain = params[:subdomain]
    status = SubdomainStatus.where(subdomain: subdomain).where(:checked_at.gte => 24.hours.ago).first
    unless status
      result = SubdomainStatusService.check(subdomain)
      status = SubdomainStatus.create!(
        subdomain: subdomain,
        active: result[:active],
        http_status: result[:http_status],
        checked_at: Time.now,
        url: result[:url],
        content_length: result[:content_length],
        title: result[:title],
        web_server: result[:web_server],
        technologies: result[:technologies],
        error: result[:error]
      )
    end
    render json: {
      subdomain: subdomain,
      active: status.active,
      http_status: status.http_status,
      url: status.url,
      content_length: status.content_length,
      title: status.title,
      web_server: status.web_server,
      technologies: status.technologies,
      error: status.error
    }
  end
end 