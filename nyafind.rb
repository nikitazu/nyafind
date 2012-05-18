#!/usr/bin/ruby

require 'net/http'
require 'rexml/document'

class Nya
  attr_accessor :title, :category, :link, :seed, :leech, :down, :description

  def print
    puts "title:     #{self.title}"
    puts "category:  #{self.category}"
    puts "link:      #{self.link}"
    puts "seed:      #{self.seed}"
    puts "leech:     #{self.leech}"
    puts "downloads: #{self.down}"
    puts
  end

  def initialize(xml)
    self.title       = xml['title'].text
    self.category    = xml['category'].text
    self.link        = xml['link'].text
    self.description = xml['description'].text

    re = /(\d+) seeder\(s\), (\d+) leecher\(s\), (\d+) downloads/i
    self.description.scan(re) do
      self.seed = Integer($1)
      self.leech = Integer($2)
      self.down = Integer($3)
    end
 end
end

def nya_query(terms)
  query = terms.join('+')
  "http://www.nyaa.eu/?page=rss&term=#{query}"
end

def nya_rss(url)
  Net::HTTP.get_response(URI.parse(url)).body
end

def nya_parse(data)
  doc = REXML::Document.new(data)
  doc.elements.each('rss/channel/item') do |xml_item|
    yield(Nya.new xml_item.elements)
  end
end

def nya_filter(rss)
  items    = []
  seed_sum = 0
  seeders  = 0

  nya_parse (rss) do |nya|
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

def main(terms)
  items = nya_filter nya_rss nya_query terms
  items.each { |nya| nya.print }
end

main ARGV

