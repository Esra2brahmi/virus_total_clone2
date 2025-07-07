class DomainsController < ApplicationController
  def scan
    domain_name = params[:query]
    @domain = Domain.where(domain: domain_name).first

    unless @domain
      service = VirusTotal::V2DomainService.new
      response = service.get_domain_report(domain_name)
      if response.success?
        data = response.parsed_response
        @domain = Domain.create!(domain: domain_name, **data)
      else
        flash[:error] = "Error fetching domain info"
        redirect_to root_path and return
      end
    end

    # Pagination for detected_urls
    per_page = 10
    @detected_urls_page = (params[:detected_urls_page] || 1).to_i
    detected_urls = @domain.detected_urls || []
    @detected_urls_total_pages = (detected_urls.size / per_page.to_f).ceil
    @detected_urls = detected_urls.slice((@detected_urls_page - 1) * per_page, per_page) || []

    # Pagination for undetected_urls
    undetected_per_page = 10
    @undetected_urls_page = (params[:undetected_urls_page] || 1).to_i
    undetected_urls = @domain.undetected_urls || []
    @undetected_urls_total_pages = (undetected_urls.size / undetected_per_page.to_f).ceil
    @undetected_urls = undetected_urls.slice((@undetected_urls_page - 1) * undetected_per_page, undetected_per_page) || []

    if request.xhr?
      if params[:detected_urls_page]
        render partial: 'domains/detected_urls', locals: { detected_urls: @detected_urls, detected_urls_page: @detected_urls_page, detected_urls_total_pages: @detected_urls_total_pages }
      elsif params[:undetected_urls_page]
        render partial: 'domains/undetected_urls', locals: { undetected_urls: @undetected_urls, undetected_urls_page: @undetected_urls_page, undetected_urls_total_pages: @undetected_urls_total_pages }
      else
        render 'domains/result'
      end
    else
      render 'domains/result'
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

  def subdomains
    domain = params[:query]
    page = (params[:page] || 1).to_i
    per_page = 10

    service = VirusTotal::DomainService.new

    # Calculate cursor based on page
    cursor = nil
    if page > 1
      response = service.get_domain_relationship(domain, "subdomains", limit: per_page)
      if response.success?
        body = response.parsed_response
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

    response = service.get_domain_relationship(domain, "subdomains", limit: per_page, cursor: cursor)

    if response.success?
      body = response.parsed_response
      @subdomains = body["data"] || []
      @total_count = body.dig("meta", "count") || 0
      @total_pages = (@total_count / per_page.to_f).ceil
      @page = page
      @query = domain
      @has_next = body.dig("links", "next").present?
    else
      @subdomains = []
      @total_count = 0
      @total_pages = 1
      @page = 1
      @query = domain
      @has_next = false
    end

    render partial: 'domains/subdomains'
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