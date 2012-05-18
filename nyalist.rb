#!/usr/bin/env ruby

require './nyalib/anime.rb'

def main(login)
  if login.nil?
    puts "ERROR: login not specified"
    puts "USAGE: nyafind mylogin"
    exit(1)
  end
  
  Anime.load_and_parse(login) do |anime|
    anime.print
    puts "\n"
  end
end

main ARGV.first
