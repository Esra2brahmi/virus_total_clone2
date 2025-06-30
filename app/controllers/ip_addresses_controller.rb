class IpAddressesController < ApplicationController
  def scan
  ip = params[:query]
  service = VirusTotal::IpService.new

  response = service.get_ip_report(ip)



  if response.success?
    @result = response.parsed_response["data"]
    all_files = service.get_all_ip_relationship(ip, "communicating_files")
    @resolutions = service.get_all_ip_relationship(ip, "resolutions")
    @referrer_files = service.get_all_ip_relationship(ip, "referrer_files")
    @whois_records = service.get_all_ip_relationship(ip, "historical_whois")
    @ssl_certs = service.get_all_ip_relationship(ip, "historical_ssl_certificates")
    @graph = service.get_all_ip_relationship(ip, "graphs")&.first



    @page = (params[:page] || 1).to_i
    per_page = 10
    @files = all_files.slice((@page - 1) * per_page, per_page) || []
    @total_pages = (all_files.size / per_page.to_f).ceil
    render 'ip_addresses/result'
  else
    flash[:error] = response.parsed_response.dig("error", "message") || "An unknown error occurred"
    redirect_to root_path
  end
end


  def reanalyze
  ip = params[:id]
  service = VirusTotal::IpService.new

  reanalyze_response = service.request_reanalyze(ip)
  unless reanalyze_response.success?
    flash[:error] = reanalyze_response.parsed_response.dig("error", "message") || "Reanalysis request failed"
    return redirect_to root_path
  end

  updated_response = service.get_ip_report(ip)

  if updated_response.success?
    @result = updated_response.parsed_response["data"]
    all_files = service.get_all_ip_relationship(ip, "communicating_files")
    @resolutions = service.get_all_ip_relationship(ip, "resolutions")
    @referrer_files = service.get_all_ip_relationship(ip, "referrer_files")
    @whois_records = service.get_all_ip_relationship(ip, "historical_whois")
    @ssl_certs = service.get_all_ip_relationship(ip, "historical_ssl_certificates")
    @graph = service.get_all_ip_relationship(ip, "graphs")&.first




    
    @page = (params[:page] || 1).to_i
    per_page = 10
    @files = all_files.slice((@page - 1) * per_page, per_page) || []
    @total_pages = (all_files.size / per_page.to_f).ceil

    flash.now[:notice] = "IP reanalyzed successfully!"
    render :result
  else
    redirect_to root_path, alert: "Failed to fetch updated scan for IP: #{ip}"
  end
end


  def relations
  ip = params[:id]
  service = VirusTotal::IpService.new

  all_files = service.get_all_ip_relationship(ip, "communicating_files")
  @referrer_files = service.get_all_ip_relationship(ip, "referrer_files")
  @resolutions = service.get_all_ip_relationship(ip, "resolutions")
  @whois_records = service.get_all_ip_relationship(ip, "historical_whois")
  @ssl_certs = service.get_all_ip_relationship(ip, "historical_ssl_certificates")
  @graph = service.get_all_ip_relationship(ip, "graphs")&.first



  
  @page = (params[:page] || 1).to_i
  per_page = 10
  @files = all_files.slice((@page - 1) * per_page, per_page) || []
  @total_pages = (all_files.size / per_page.to_f).ceil

  render 'ip_addresses/relations'
rescue => e
  flash[:error] = "Failed to load communicating files."
  redirect_to root_path
end

def show
  ip = params[:query]
  service = VirusTotal::IpService.new

  response = service.get_ip_report(ip)
  all_files = service.get_all_ip_relationship(ip, "communicating_files")

  if response.success?
    @result = response.parsed_response["data"]

    @page = (params[:page] || 1).to_i
    per_page = 10
    @total_pages = (all_files.size / per_page.to_f).ceil
    @files = all_files.slice((@page - 1) * per_page, per_page) || []

    render 'ip_addresses/result'
  else
    flash[:error] = response.parsed_response.dig("error", "message") || "An unknown error occurred"
    redirect_to root_path
  end
end


end