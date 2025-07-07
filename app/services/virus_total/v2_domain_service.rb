module VirusTotal
  class V2DomainService
    include HTTParty
    base_uri 'https://www.virustotal.com/vtapi/v2'

    def initialize(api_key = ENV['VT_API_KEY'])
      @api_key = api_key
    end

    def get_domain_report(domain)
      self.class.get('/domain/report', query: { apikey: @api_key, domain: domain })
    end
  end
end 