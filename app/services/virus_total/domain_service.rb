module VirusTotal
  class DomainService
    include HTTParty
    base_uri 'https://www.virustotal.com/api/v3'

    def initialize(api_key = ENV['VT_API_KEY'])
      @headers = {
        "x-apikey" => api_key,
        "accept" => "application/json"
      }
    end

    def get_domain_report(domain)
      self.class.get("/domains/#{domain}", headers: @headers)
    end

    def get_domain_relationship(domain, relationship, limit: 10, cursor: nil)
      params = { limit: limit }
      params[:cursor] = cursor if cursor
    
      self.class.get(
        "/domains/#{domain}/#{relationship}",
        headers: @headers,
        query: params
      )
    end

    def get_all_domain_relationship(domain, relationship)
      results = []
      url = "/domains/#{domain}/#{relationship}"

      Rails.logger.info "Fetching domain relationship: #{domain}/#{relationship}"

      loop do
        response = self.class.get(url, headers: @headers)
        break unless response.success?

        body = response.parsed_response

        Rails.logger.info "Response data count: #{body['data']&.size || 0}"
        Rails.logger.info "Next link: #{body.dig('links', 'next')}"

        results.concat(body["data"]) if body["data"]

        next_link = body.dig("links", "next")
        break unless next_link

        # Convert the full next_link URL to relative path for HTTParty
        uri = URI(next_link)
        url = uri.path + (uri.query ? "?#{uri.query}" : "")
      end

      Rails.logger.info "Total results collected: #{results.size}"
      results
    end
    
  end
end 