#!/usr/bin/env ruby

require 'net/http'
require 'nokogiri'

module Anime
  
  def Anime.create_title(row, link)
    title = ''
    airing = false
    current = 0
    max = 0
    
    row[1].scan(/\n(.+)$/i) do
      title = $1.strip
    end
      
    if (title.end_with?('Airing'))
      title = title.slice(0, title.length - ' Airing'.length)
      airing = true
    end

    row[4].scan(/^(\d+)\/(\d+|-)/) do
      current = Integer($1)
      max = $2
      if max == '-'
        max = 0
      end
    end
    
    return { 
      :title    => title, 
      :airing   => airing, 
      :score    => row[2], 
      :type     => row[3], 
      :current  => current,
      :max      => max,
      :link     => link
    }
  end
  
  def Anime.progress_next_string(title)
    
    value = title[:current] + 1
    max   = title[:max]
    
    if max == 0
      if value < 10
        return "0#{value}"
      else
        return value.to_s
      end
        
    else
        
      if max.to_s.length <= value.to_s.length
        return "#{value}"
      else
        zeros = '0' * (max.to_s.length - value.to_s.length)
        return zeros + value.to_s
      end

    end
  end
  
  def Anime.load_and_parse(login, status_id)
    data = load_url(login, status_id)
    parse(data) do |anime|
      yield(anime)
    end
  end
  
  def Anime.load_url(login, status_id)
    url = "http://myanimelist.net/animelist/#{login}&status=#{status_id}&order=0"
    Net::HTTP.get_response(URI.parse(url)).body
  end
  
  
  def Anime.parse(html)
    
    doc = Nokogiri::HTML(html)
    
    data = []
    doc.css('html>body>div#list_surround td').each do |td|
      data << td.content
    end
    
    links = []
    doc.css('html>body>div#list_surround a.animetitle').each do |a|
      links << a.attr('href')
    end
    
    index = 0
    data = data.drop(13)
    columns = 6
    stop = false
    table = []
    while not data.length < columns do
      table << create_title(data.take(columns), links[index])
      data = data.drop(columns)
      index = index + 1
    end
    
    table.each do |anime|
      yield(anime)
    end
  
  end #parse
  
  def Anime.extract_image(link)
    html = Net::HTTP.get_response(URI.parse(link)).body
    doc = Nokogiri::HTML(html)
    doc.css('div#content table tr td.borderClass img').first.attr('src')
  end

end # Nya module

