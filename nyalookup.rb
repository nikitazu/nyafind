#!/usr/bin/env ruby

# ======================================== #
# Find animes at myanimelist.net and       #
# lookup for their new series on torrents  #
# ======================================== #

$:.unshift(File.dirname(__FILE__) + '/nyalib')

require 'anime.rb'
require 'torrent.rb'

def main(login)
  if login.nil?
    login = `whoami`
    login.strip!
  end
  
  Anime.load_and_parse(login) do |anime|
    puts "#{anime[:title]} #{anime[:current]} / #{anime[:max]}"
    puts "============================================================"
    puts
    query = "#{anime[:title]} #{Anime.progress_next_string(anime)}"
    Torrent.load_and_parse(query.split(' ')) do |link|
      puts link[:title]
      puts link[:link]
      puts
    end
  end
end

main ARGV.first
