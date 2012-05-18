#!/usr/bin/env ruby

require 'net/http'
require 'scrapi'

class Anime
  attr_accessor :title, :score, :type, :progress
  
  def airing?
    @is_airing
  end

  def initialize(row)
    row[1].scan(/\n(.+)(Airing?)$/i) do
      self.title = $1
      @is_airing = $2
    end

    self.score = row[2]
    self.type = row[3]
    self.progress = Progress.new(row[4])
  end
  
  def print
    puts "Anime: #{self.title}"
    puts "Score: #{self.score}"
    if airing?
      puts "Progress: #{self.progress} (Airing)"
    else
      puts "Progress: #{self.progress}"
    end
  end

end # Anime


class Progress
  attr_accessor :current, :max
  
  def initialize(data)
    data.scan(/^(\d+)\/(\d+|-)/) do
      self.current = $1
      self.max = $2
    end
  end
  
  def to_s
    "#{self.current}/#{self.max}"
  end
end


def nya_list(login)
  url = "http://myanimelist.net/animelist/#{login}&status=1&order=0"
  Net::HTTP.get_response(URI.parse(url)).body
end


def nya_parse(html)

  scraper = Scraper.define do 
    array :tables
    process "html>body>div#list_surround td", :tables => :text
    result :tables
  end
  
  data = scraper.scrape(html).drop(13)
  columns = 6
  stop = false
  table = []
  while not data.length < columns do
    table << Anime.new(data.take(columns))
    data = data.drop(columns)
  end
  
  table.each do |anime|
    anime.print
    puts "\n"
  end
end


nya_parse nya_list ARGV.first

