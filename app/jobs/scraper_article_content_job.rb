class ScraperArticleContentJob < ApplicationJob
  queue_as :default

  def perform(source_url, article_link)
    scraper = Services::ScraperFactory.create_scraper(source_url)

    source = Source.find_by(link: source_url)
    source_id = source.id if source

    scraper.scrape_page_content(article_link, source_id)

    Rails.logger.info "ScraperArticleContentJob: Contenido procesado para #{article_link}"
  rescue StandardError => e
    Rails.logger.error "Error en ScraperArticleContentJob para #{article_link}: #{e.message}"
    raise e
  end
end
