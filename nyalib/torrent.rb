#!/usr/bin/env ruby

require 'net/http'
require 'rexml/document'

module Torrent
  
  def Torrent.create_link(xml)
    description = xml['description'].text
    seed = 0
    leech = 0
    down = 0
    
    re = /(\d+) seeder\(s\), (\d+) leecher\(s\), (\d+) download\(s\)/i
    description.scan(re) do
      seed = Integer($1)
      leech = Integer($2)
      down = Integer($3)
    end
    
    return {
      :title => xml['title'].text,
      :category => xml['category'].text,
      :link => xml['link'].text,
      :description => description,
      :seed => seed,
      :leech => leech,
      :down => down
    }
  end
  
  def Torrent.matches_series(torrent, series)
    temp = String.new(torrent[:title])
    temp.gsub! /(\[[0-9a-f]+#{series}[0-9a-f]+\])/i, ''
    temp.gsub! /1920x1080/, ''
    temp.gsub! /1280x720/, ''
    temp.gsub! /\[720p\]/, ''
    temp.gsub! /320K+/, ''
    return temp.include?(series)
  end
  
  def Torrent.load_and_parse(terms)
    items = filter load query terms
    items.each { |link| yield(link) }
  end
  
  def Torrent.query(terms)
    query = terms.join('+')
    "http://www.nyaa.eu/?page=rss&term=#{query}"
  end
  
  def Torrent.load(url)
    Net::HTTP.get_response(URI.parse(url)).body
  end
  
  def Torrent.parse(data)
    doc = REXML::Document.new(data)
    doc.elements.each('rss/channel/item') do |xml_item|
      yield(create_link xml_item.elements)
    end
  end
  
  def Torrent.filter(rss)
    items    = []
    seed_sum = 0
    seeders  = 0
    
    parse (rss) do |nya|
      if nya[:seed] > 0
        seed_sum += nya[:seed]
        seeders  += 1
        items << nya
      end
    end

    if seeders > 0
      seed_avg = seed_sum / seeders
      items = items.find_all { |nya| nya[:seed] >= seed_avg }
    end
    
    sorted = items.sort_by { |nya| nya[:seed] }
    sorted.reverse
  end
  
end # module Torrent
