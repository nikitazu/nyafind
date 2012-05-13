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
end

def nya_query(terms)
  query = terms.join('+')
  "http://www.nyaa.eu/?page=rss&term=#{query}"
end

def nya_query2(*terms)
  nya_query(terms)
end

def nya_rss(url)
  Net::HTTP.get_response(URI.parse(url)).body
end

def nya_parse(data)
  doc = REXML::Document.new(data)
  doc.elements.each('rss/channel/item') do |e|
    items           = e.elements
    nya             = Nya.new

    nya.title       = items['title'].text
    nya.category    = items['category'].text
    nya.link        = items['link'].text
    nya.description = items['description'].text

    nya.description.scan(/(\d+) seeder\(s\), (\d+) leecher\(s\), (\d+) downloads/i) do
      nya.seed = Integer($1)
      nya.leech = Integer($2)
      nya.down = Integer($3)

      yield(nya)
    end
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
  rss = nya_rss nya_query terms
  items = nya_filter rss
  items.each { |nya| nya.print }
end

main ARGV

