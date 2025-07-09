class SubdomainStatusService
  # Checks if a subdomain is active using httpx CLI, tries both http and https
  HTTPX_PATH = "/home/esra/go/bin/httpx"
  def self.check(subdomain)
    urls = ["https://#{subdomain}", "http://#{subdomain}"]
    urls.each do |url|
      output = `echo "#{url}" | #{HTTPX_PATH} -status-code -timeout 5 2>/dev/null`
      Rails.logger.info "HTTPX CHECK: #{url} => #{output.inspect}"  # LOG TO RAILS LOGS
      # Remove ANSI color codes
      output = output.gsub(/\e\[[\d;]*m/, '')
      if output =~ /\[(\d+)\]/
        status_code = $1.to_i
        active = status_code >= 200 && status_code < 400
        return { active: active, http_status: status_code }
      end
    end
    { active: false, http_status: nil }
  end
end 