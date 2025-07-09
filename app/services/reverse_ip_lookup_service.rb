class ReverseIpLookupService
  ENDPOINT = "https://api.viewdns.info/reverseip/"
  API_KEY = "85e7444cb6bf4986f7fa47ac132328d80cfdd427"

  def self.lookup(ip)
    response = HTTParty.get(ENDPOINT, query: {
      host: ip,
      apikey: API_KEY,
      output: 'json'
    })
    if response.success?
      data = response.parsed_response
      domains = data.dig("response", "domains")
      # Only return if it's an array of hashes with 'name'
      if domains.is_a?(Array) && domains.all? { |d| d["name"].present? }
        domains
      else
        []
      end
    else
      []
    end
  end
end 