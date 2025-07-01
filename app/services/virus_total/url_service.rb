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

    def get_url_report(url)
      url_id = Base64.urlsafe_encode64(url).gsub(/=+$/, "")
      self.class.get("/urls/#{url_id}", headers: @headers)
    end
  end
end