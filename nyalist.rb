#!/usr/bin/env ruby

$:.unshift(File.dirname(__FILE__) + '/nyalib')

require 'anime.rb'

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
