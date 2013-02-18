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
    anime.print_short
    puts "============================================================"
    puts
    
    query = "#{anime.title} #{anime.progress.next}"
    
    Torrent.load_and_parse(query.split(' ')) do |link|
      link.print_short
      puts
    end
  end
end

main ARGV.first
