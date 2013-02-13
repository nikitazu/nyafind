#!/usr/bin/env ruby

require 'net/http'
require 'rexml/document'

module Torrent
  
  class Link
    attr_accessor :title, :category, :link, :seed, :leech, :down, :description
    
    def initialize(xml)
      self.title       = xml['title'].text
      self.category    = xml['category'].text
      self.link        = xml['link'].text
      self.description = xml['description'].text
      
      re = /(\d+) seeder\(s\), (\d+) leecher\(s\), (\d+) download\(s\)/i
      self.description.scan(re) do
        self.seed = Integer($1)
        self.leech = Integer($2)
        self.down = Integer($3)
      end
    end
    
    def print
      puts "title:     #{self.title}"
      puts "category:  #{self.category}"
      puts "link:      #{self.link}"
      puts "seed:      #{self.seed}"
      puts "leech:     #{self.leech}"
      puts "downloads: #{self.down}"
    end
    
    def print_short
      puts "#{@title} (#{@seed}/#{leech})"
      puts @link
    end

  end # class Link
  
  
  def Torrent.load_and_parse(terms)
    items = filter load query terms
    items.each { |link| yield(link) }
  end
  
  def Torrent.query(terms)
    query = terms.join('+')
    "http://www.nyaa.eu/?page=rss&term=#{query}"
  end
  
  def Torrent.load(url)
    #puts url
    Net::HTTP.get_response(URI.parse(url)).body
  end
  
  def Torrent.parse(data)
    doc = REXML::Document.new(data)
    doc.elements.each('rss/channel/item') do |xml_item|
      yield(Link.new xml_item.elements)
    end
  end
  
  def Torrent.filter(rss)
    items    = []
    seed_sum = 0
    seeders  = 0
    
    parse (rss) do |nya|
      if nya.seed > 0
        seed_sum += nya.seed
        seeders  += 1
        items << nya
      end
    end

    if seeders > 0
      seed_avg = seed_sum / seeders
      items = items.find_all { |nya| nya.seed >= seed_avg }
    end
    
    sorted = items.sort_by { |nya| nya.seed }
    sorted.reverse
  end
  
end # module Torrent
