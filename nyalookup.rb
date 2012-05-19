#!/usr/bin/env ruby

require './nyalib/anime.rb'
require './nyalib/torrent.rb'

def main(login)
  if login.nil?
    puts "ERROR: login not specified"
    puts "USAGE: nyalookup mylogin"
    exit(1)
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
