class WebsitesStatusWorker
  include Sidekiq::Worker
  sidekiq_options queue: :default

  def perform
    Website.all.map(&:enqueu_status_check)
  end
end
