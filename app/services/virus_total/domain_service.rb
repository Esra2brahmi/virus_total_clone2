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
  end
end 