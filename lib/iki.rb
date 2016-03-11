require 'wikipedia'
require 'wikicloth'
require 'active_support/all'

require_relative "./format.rb"

class Iki

  # use the "search" factory to instantiate, not initialize
  def self.search(query, gets_chomping=true)
    page = Wikipedia.find(query)
    puts "at #{query}".green
    return self.new(page, gets_chomping)
  end

  def sections_for(content)
    section_names = content.scan(/\=\=.+\=\=/)
    section_vals = content.split(/\=\=.+\=\=/)
    section_names.reduce({}) do |memo, name|
      memo[
        name.tr("=", "").lstrip.rstrip.downcase.gsub(" ", "_").to_sym
      ] = WikiCloth::Parser.new({
        data: section_vals[memo.keys.length],
        params: {}
      }).to_html
      memo
    end

  end

  def print_content_section(name)
    tempfile = Tempfile.new
    path = tempfile.path
    tempfile.write(page[:subsections][name])
    tempfile.close
    puts `cat #{path} | w3m -dump -T text/html`
  end

  def select_option(obj)
    puts "options: #{obj.keys.join(", ").green}"
    puts "enter choice: "
    print_section(gets.chomp.to_sym) ? obj : nil
  end

  def print_section(section)
    return nil unless page.has_key?(section.to_sym)
    if section == :content
      puts "Choose a subsection: #{page[:subsections].keys.join(", ").blue}"
      print_content_section(gets.chomp.to_sym)
    else
      puts Format.formatted_heredoc(<<-TEXT
        #{"\n#{section.capitalize}\n".red_on_black}
        #{"\n#{self.page[section.to_sym]}\n"}
       TEXT
       )
    end
    return true
  end

  attr_accessor :page
  def initialize(page, gets_chomping=true)
    @page =  {
      title: page.title,
      fullurl: page.fullurl,
      # text: page.text,
      content: page.content,
      subsections: sections_for(page.content),
      # summary: page.summary,
      categories: page.categories,
      links: page.links,
      extlinks: page.extlinks,
      image_urls: page.image_urls,
    }
    if gets_chomping
      loop do
        next_page = select_option(@page)
        @page = next_page if next_page
        break unless next_page
      end
    end
  end
end