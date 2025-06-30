module VirusTotal
    class IpService
      include HTTParty
      base_uri 'https://www.virustotal.com/api/v3'
  
      def initialize(api_key = ENV['VT_API_KEY'])
        @headers = {
          "x-apikey" => api_key,
          "accept" => "application/json"
        }
      end
  
      def get_ip_report(ip)
        self.class.get("/ip_addresses/#{ip}", headers: @headers)
      end

      def request_reanalyze(ip)
        self.class.post("/ip_addresses/#{ip}/analyse", headers: @headers)
      end
      
      def get_all_ip_relationship(ip, relationship)
          results = []
          url = "/ip_addresses/#{ip}/#{relationship}"

          loop do
            response = self.class.get(url, headers: @headers)
            break unless response.success?

            body = response.parsed_response

            results.concat(body["data"]) if body["data"]

            next_link = body.dig("links", "next")
            break unless next_link

            # Convert the full next_link URL to relative path for HTTParty
            uri = URI(next_link)
            url = uri.path + (uri.query ? "?#{uri.query}" : "")
          end

          results
        end

      end
  end
  