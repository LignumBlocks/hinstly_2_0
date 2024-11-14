# app/services/scrapers/scraper_consumer_financial.rb
module Scrapers
  class ScraperConsumerFinancial < BaseScraper
    include HTTParty

    def max_pages
      response = HTTParty.get(url, headers: default_headers)
      document = Nokogiri::HTML(response.body)
      document.at_css("input#m-pagination__current-page-0")["max"].to_i
    end

    def scrape_links(page_number)
      page_url = "#{url}?page=#{page_number}"
      response = HTTParty.get(page_url, headers: default_headers)
      document = Nokogiri::HTML(response.body)

      articles = document.css("article.o-post-preview")
      articles.map do |article|
        link_element = article.at_css("h3.o-post-preview__title a")
        URI.join(page_url, link_element["href"]).to_s if link_element
      end.compact
    end

    def scrape_page_content(link)
      response = HTTParty.get(link, headers: default_headers)
      document = Nokogiri::HTML(response.body)

      metadata = scrape_page_metadata(document)
      puts metadata

      content = document.css("div.u-layout-grid__main").text.strip
      content = content.gsub(/\s+/, " ").squeeze(" ")
    end

    private

    def scrape_page_metadata(document)
      title = document.css("div.o-item-introduction h1").text.strip

      date_element = document.at_css("div.o-item-introduction .a-date time")
      publication_date = date_element ? date_element["datetime"] : nil

      topics = document.css("ul.m-tag-group li a .a-tag-topic__text").map(&:text)

      metadata = {
        title: title,
        publication_date: publication_date,
        topics: topics
      }

      metadata
    end

    def default_headers
      {
        "User-Agent" => "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36",
        "Accept-Language" => "en-US,en;q=0.9"
      }
    end
  end
end
