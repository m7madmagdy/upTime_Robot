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
      website.status = res.is_a?(Net::HTTPSuccess) ? 'UP' : 'DOWN'
    rescue StandardError => e
      website.status = 'DOWN'
    ensure
      website.save
    end
  end
end
