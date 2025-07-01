class DomainsController < ApplicationController
  def scan
    domain = params[:query]
    service = VirusTotal::DomainService.new
    response = service.get_domain_report(domain)

    if response.success?
      @result = response.parsed_response["data"]
      render 'domains/result'
    else
      flash[:error] = response.parsed_response.dig("error", "message") || "An unknown error occurred"
      redirect_to root_path
    end
  end
end 