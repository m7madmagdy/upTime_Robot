require 'uri'
require 'net/http'

class WebsiteStatusWorker
  include Sidekiq::Worker
  sidekiq_options queue: :website_status

  def perform(id)
    website = Website.find id
    website.last_checked_at = Time.now
    puts "The website url is: #{website.url}"

    begin
      uri = URI(website.url)
      res = Net::HTTP.get_response(uri)
      website.status = res.is_a?(Net::HTTPSuccess) ? success? : failure?
    rescue StandardError => e
      website.status = failure?
    ensure
      website.save
    end
  end

  def success?; 'Up' end

  def failure?; 'Down' end
end
