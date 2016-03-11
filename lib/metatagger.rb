require 'metainspector'
require 'mechanize'

require_relative "./http_scraper.rb"

AGENT ||= Mechanize.new

class Metatagger
  def self.search(query, page=0)
    # returns urls from google results
    query = "http://google.com/search?q=#{URI.encode(query)}"
    http_response = AGENT.get(query)
    titles = HttpScraper.scrape_titles(http_response)
    links  = HttpScraper.scrape_links(http_response)
    descriptions = HttpScraper.scrape_descriptions(http_response)
    return (titles.length - 1).times.map do |i|
      {
        title: titles[i],
        link: links[i],
        descriptions: descriptions[i]
      }
    end
  end

  def self.search_site(site, query, page=0)
    search("site:#{URI.encode(site)} #{URI.encode(query)}")
  end

end