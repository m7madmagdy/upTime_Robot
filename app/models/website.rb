class Website < ApplicationRecord
  validates :name, presence: true
  validates :url, presence: true

  URL_REGEXP = %r{\A(http|https)://[a-z0-9]+([\-.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(/.*)?\z}ix
  validates :url, format: { with: URL_REGEXP }

  def enqueu_status_check
    WebsiteStatusWorker.perform_async(id)
  end

end
