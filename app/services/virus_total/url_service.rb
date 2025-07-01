module VirusTotal
  class UrlService
    include HTTParty
    base_uri 'https://www.virustotal.com/api/v3'

    def initialize(api_key = ENV['VT_API_KEY'])
      @headers = {
        "x-apikey" => api_key,
        "accept" => "application/json"
      }
    end

    # Scan a URL
    def scan_url(url)
      self.class.post("/urls", 
        headers: @headers,
        body: { url: url }.to_json
      )
    end

    # Get URL report
    def get_url_report(url_id)
      self.class.get("/urls/#{url_id}", headers: @headers)
    end

    # Reanalyze URL
    def request_reanalyze(url_id)
      self.class.post("/urls/#{url_id}/analyse", headers: @headers)
    end
  end
end