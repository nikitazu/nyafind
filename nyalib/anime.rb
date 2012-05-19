#!/usr/bin/env ruby

require 'net/http'
require 'scrapi'

module Anime
  
  class Title
    attr_accessor :title, :score, :type, :progress
    
    def airing?
      @is_airing
    end
    
    def title_airing
      if self.airing?
        "#{@title} (Airing)"
      else
        @title
      end
    end
    
    def initialize(row)
      row[1].scan(/\n(.+)$/i) do
        self.title = $1
      end
      
      if (@title.end_with?('Airing'))
        @title = @title.slice(0, @title.length - ' Airing'.length)
        @is_airing = true
      else
        @is_airing = false
      end
      
      self.score = row[2]
      self.type = row[3]
      self.progress = Progress.new(row[4], self)
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
    
    def print_short
      puts "#{self.title_airing} [#{self.progress}]"
    end
  end # Title
  
  
  class Progress
    attr_accessor :current, :max
    
    def initialize(data, anime)
      data.scan(/^(\d+)\/(\d+|-)/) do
        @current = Integer($1)
        @max = $2
      end
      @anime = anime
      if @current.nil?
        @current = 0
      end
      if @max.nil?
        @max = '-'
      end
    end
    
    def next
      value = @current + 1
      
      if @max == '-'
        if value < 10
          return "0#{value}"
        else
          return value.to_s
        end
        
      else
        
        if @max.length <= value.to_s.length
          return "#{value}"
        else
          zeros = '0' * (@max.length - value.to_s.length)
          return zeros + value.to_s
        end

      end
    end # next
    
    def to_s
      "#{@current}/#{@max}"
    end

  end # end class Progress
  
  
  def Anime.load_and_parse(login)
    data = load_url(login)
    
    parse(data) do |anime|
      yield(anime)
    end
  end
  
  
  def Anime.load_url(login)
    url = "http://myanimelist.net/animelist/#{login}&status=1&order=0"
    Net::HTTP.get_response(URI.parse(url)).body
  end
  
  
  def Anime.parse(html)
    
    scraper = Scraper.define do 
      array :tables
      process "html>body>div#list_surround td", :tables => :text
      result :tables
    end
    
    data = scraper.scrape(html)
    
    return nil if data.nil?
    
    data = data.drop(13)
    columns = 6
    stop = false
    table = []
    while not data.length < columns do
      table << Title.new(data.take(columns))
      data = data.drop(columns)
    end
    
    table.each do |anime|
      yield(anime)
    end
  
  end #parse

end # Nya module

