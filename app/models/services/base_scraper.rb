# app/services/scrapers/base_scraper.rb
module Services
  class BaseScraper
    attr_reader :url

    def initialize(url)
      @url = url
    end

    # Método para obtener el número máximo de páginas en la paginación
    def max_pages
      raise NotImplementedError, 'all scrapper must implement this method'
    end

    # Método para extraer los enlaces en una página específica
    def scrape_links(page_number)
      raise NotImplementedError, 'all scrapper must implement this method'
    end

    # Método para extraer el contenido de una página
    def scrape_page_content(link)
      raise NotImplementedError, 'all scrapper must implement this method'
    end
  end
end
