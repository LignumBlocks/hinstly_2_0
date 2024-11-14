# app/models/services/scraper_factory.rb
module Services
  class ScraperFactory
    def self.create_scraper(url)
      puts "creado #{url}"
      case url
      when 'https://www.consumerfinance.gov/about-us/blog/'
        ScraperConsumerFinancial.new(url)
      else
        raise "there is not scraper for this site: #{url}"
      end
    end
  end
end
