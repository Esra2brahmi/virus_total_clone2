class UrlsController < ApplicationController
  def scan
    url = params[:query]
    service = VirusTotal::UrlService.new

    # First try to get existing report
    report = service.get_url_report(url)
    
    if report.success?
      @result = report.parsed_response["data"]
      render 'urls/result'
    else
      # If no existing report, submit for scanning
      scan_response = service.scan_url(url)
      if scan_response.success?
        @result = { "data" => { 
          "id" => url,
          "attributes" => {
            "status" => "queued",
            "message" => "Scan submitted. Please check back later."
          }
        }}
        render 'urls/result'
      else
        flash[:error] = scan_response.parsed_response["error"]["message"]
        redirect_to root_path
      end
    end
  end
end