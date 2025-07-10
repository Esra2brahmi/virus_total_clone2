require 'open3'

class WaybackurlsService
  WAYBACKURLS_PATH = "/home/esra/go/bin/waybackurls" # adjust if needed

  def self.fetch(domain)
    stdout, stderr, status = Open3.capture3("echo #{domain} | #{WAYBACKURLS_PATH}")
    return [] unless status.success?
    stdout.split("\n").map(&:strip).uniq
  end
end 