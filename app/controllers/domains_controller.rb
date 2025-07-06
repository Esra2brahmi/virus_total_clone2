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


  def communicating_files
    domain = params[:query]
    page = (params[:page] || 1).to_i
    per_page = 10
    
    service = VirusTotal::DomainService.new
    
    # Calculate cursor based on page
    cursor = nil
    if page > 1
      # For simplicity, we'll fetch the first page and then the requested page
      # In a production app, you'd want to store cursors or use a different approach
      response = service.get_domain_relationship(domain, "communicating_files", limit: per_page)
      if response.success?
        body = response.parsed_response
        # Get the cursor for the requested page
        (page - 1).times do
          next_link = body.dig("links", "next")
          break unless next_link
          
          uri = URI(next_link)
          url = uri.path + (uri.query ? "?#{uri.query}" : "")
          response = service.class.get(url, headers: service.instance_variable_get(:@headers))
          break unless response.success?
          body = response.parsed_response
        end
        cursor = body.dig("meta", "cursor")
      end
    end
    
    # Get the actual page data
    response = service.get_domain_relationship(domain, "communicating_files", limit: per_page, cursor: cursor)
    
    if response.success?
      body = response.parsed_response
      @files = body["data"] || []
      @total_count = body.dig("meta", "count") || 0
      @total_pages = (@total_count / per_page.to_f).ceil
      @page = page
      @query = domain
      @has_next = body.dig("links", "next").present?
      @has_prev = page > 1
    else
      @files = []
      @total_count = 0
      @total_pages = 1
      @page = 1
      @query = domain
      @has_next = false
      @has_prev = false
    end

    render partial: 'domains/communicating_files'
  end

  def debug_api
    domain = params[:query] || "google.com"
    service = VirusTotal::DomainService.new
    
    # Test the API response directly
    response = service.get_domain_relationship(domain, "communicating_files", limit: 10)
    
    if response.success?
      body = response.parsed_response
      render json: {
        success: true,
        data_count: body["data"]&.size || 0,
        total_count: body.dig("meta", "count"),
        has_next: body.dig("links", "next").present?,
        sample_data: body["data"]&.first(2),
        full_response: body
      }
    else
      render json: {
        success: false,
        error: response.parsed_response
      }
    end
  end
  
end 