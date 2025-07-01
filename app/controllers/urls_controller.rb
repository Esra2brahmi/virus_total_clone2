class UrlsController < ApplicationController
  def scan
    url = params[:query]
    service = VirusTotal::UrlService.new

    # First submit URL for scanning
    scan_response = service.scan_url(url)
    unless scan_response.success?
      flash[:error] = scan_response.parsed_response.dig("error", "message") || "Failed to submit URL for scanning"
      return redirect_to root_path
    end

    # Then fetch the report using the URL ID
    url_id = Base64.urlsafe_encode64(url).gsub(/=+$/, "")
    report_response = service.get_url_report(url_id)

    if report_response.success?
      @result = report_response.parsed_response["data"]
      render 'urls/result'
    else
      flash[:error] = report_response.parsed_response.dig("error", "message") || "Failed to fetch URL report"
      redirect_to root_path
    end
  end

  def reanalyze
    url_id = params[:id]
    service = VirusTotal::UrlService.new

    reanalyze_response = service.request_reanalyze(url_id)
    unless reanalyze_response.success?
      flash[:error] = reanalyze_response.parsed_response.dig("error", "message") || "Reanalysis request failed"
      return redirect_to root_path
    end

    updated_response = service.get_url_report(url_id)
    if updated_response.success?
      @result = updated_response.parsed_response["data"]
      flash.now[:notice] = "URL reanalyzed successfully!"
      render :result
    else
      redirect_to root_path, alert: "Failed to fetch updated scan for URL"
    end
  end
end