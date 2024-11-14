# app/jobs/scraper_page_job.rb
class ScraperPageJob < ApplicationJob
  queue_as :default

  def perform(url, page_number)
    scraper = Scrapers::ScraperFactory.create_scraper(url)
    links = scraper.scrape_links(page_number)

    links.each do |link|
      ScraperArticleContentJob.perform_later(url, link)
    end

  rescue StandardError => e
    Rails.logger.error "Error en ScraperPageJob para #{url} página #{page_number}: #{e.message}"
    raise e
  end
end
