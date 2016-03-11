require 'mechanize'

AGENT ||= Mechanize.new

class HttpScraper
  # Specifically for Google search results

  def self.scrape_titles(text)
    text.css("#ires > ol > div > h3 > a").map(&:content)
  end
  
  def self.scrape_links(text)
    text.css("#ires > ol > div > h3 > a").map do |node|
      link = node.attributes["href"].value.gsub("/url?q=", "")
      link = link[0...link.index('&')]
    end 
  end
  
  def self.scrape_descriptions(text)
    text.css("#ires > ol > div > div > span").map do |node|
      node.content
    end
  end

end
