class ScraperLinkJob < ApplicationJob
  queue_as :default

  def perform(url)
    scraper = Scrapers::ScraperFactory.create_scraper(url)
    max_pages = scraper.max_pages

    (1..1).each do |page_number|
      ScraperPageJob.perform_later(url, page_number)
    end

  Rails.logger.info "ScraperLinkJob: Todos los jobs secundarios han sido encolados para #{url}"
  end
end
