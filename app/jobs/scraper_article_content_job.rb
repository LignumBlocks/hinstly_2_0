class ScraperArticleContentJob < ApplicationJob
  queue_as :default

  def perform(source_url, article_link)
    scraper = Services::ScraperFactory.create_scraper(source_url)

    source = Source.find_by(link: source_url)
    source_id = source.id if source

    content = scraper.scrape_page_content(article_link, source_id)

    filename = "article_#{Digest::MD5.hexdigest(article_link)}.txt"

    File.open(Rails.root.join(filename), 'w') do |file|
      file.puts "URL: #{article_link}"
      file.puts content
    end

    Rails.logger.info "ScraperArticleContentJob: Contenido procesado para #{article_link}"
  rescue StandardError => e
    Rails.logger.error "Error en ScraperArticleContentJob para #{article_link}: #{e.message}"
    raise e
  end
end
