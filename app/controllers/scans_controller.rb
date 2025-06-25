require "dotenv/load"
require "virustotalx"

class ScansController < ApplicationController
  def new
  end

  def create
    if params[:file].present?
      handle_file_scan
    elsif params[:url].present?
      handle_url_scan
    else
      redirect_to new_scan_path, alert: "Please provide a URL or a file."
    end
  end

  def show
    api = VirusTotal::API.new
    @scan_type = params[:type]
    @analysis_id = params[:id]

    if @scan_type == 'file'
      analysis = api.analysis.get(@analysis_id)
      if analysis["data"]["attributes"]["status"] != "completed"
        @results = nil
        return
      end

      sha256 = analysis.dig("meta", "file_info", "sha256")
      unless sha256
        @error = "Could not extract SHA256 from analysis response."
        return
      end

      file_report = api.file.get(sha256)
      if file_report["data"] && file_report["data"]["attributes"]
        @results = file_report["data"]["attributes"]
      else
        @error = "Failed to fetch file report: #{file_report.inspect}"
      end
    else # URL scan
      analysis = api.analysis.get(@analysis_id)
      if analysis["data"] && analysis["data"]["attributes"]
        @results = analysis["data"]["attributes"]
      else
        @error = "Failed to fetch results: #{analysis.inspect}"
      end
    end
  end

  private

  def handle_url_scan
    api = VirusTotal::API.new
    response = api.url.analyse(params[:url])
    if response["data"] && response["data"]["id"]
      analysis_id = response["data"]["id"]
      redirect_to scan_path(id: analysis_id, type: 'url')
    else
      render plain: "Failed to scan URL: #{response.inspect}"
    end
  end

  def handle_file_scan
    api = VirusTotal::API.new
    file = params[:file]
    response = api.file.upload(file.tempfile.path)
    if response["data"] && response["data"]["id"]
      analysis_id = response["data"]["id"]
      redirect_to scan_path(id: analysis_id, type: 'file')
    else
      render plain: "Failed to scan file: #{response.inspect}"
    end
  end
end
