#!/usr/bin/env ruby

$:.unshift(File.dirname(__FILE__) + '/nyalib')

require 'json'
require 'anime.rb'

def main(link)
  if link.nil?
    puts "ERROR: link not specified"
    puts "USAGE: nyaimage http://anime/link/to/find/image"
    exit(1)
  end
  
  image = Anime.extract_image(link)
  puts image
end

main ARGV.first
