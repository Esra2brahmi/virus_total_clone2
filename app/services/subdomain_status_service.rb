require 'open3'

class SubdomainStatusService
  HTTPX_PATH = "/home/esra/go/bin/httpx"  # make sure this is correct

  def self.check(subdomain)
    url = subdomain.include?("http") ? subdomain : "https://#{subdomain}"

    command = "echo #{url} | #{HTTPX_PATH} -status-code -web-server -tech-detect -content-length -title -no-color -timeout 5"
    stdout, stderr, status = Open3.capture3(command)

    return { active: false, error: stderr.strip } unless status.success?

    line = stdout.strip
    return { active: false, error: "No output" } if line.empty?

    parts = line.split(/\s+/)
    url = parts[0] || 'N/A'
    http_status = parts[1] || 'N/A'
    content_length = parts[2] || 'N/A'
    title = parts[3] || 'N/A'
    web_server = parts[4] || 'N/A'
    technologies = parts[5] ? parts[5].split(',').map(&:strip) : []

    {
      active: http_status.to_i >= 200 && http_status.to_i < 400,
      url: url,
      http_status: http_status,
      content_length: content_length,
      title: title,
      web_server: web_server,
      technologies: technologies
    }
  end
end 