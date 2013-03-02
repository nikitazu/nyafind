#!/usr/bin/env ruby

$:.unshift(File.dirname(__FILE__) + '/nyalib')

require 'json'
require 'torrent.rb'

def main(terms)
  puts '['
  Torrent.load_and_parse(terms) do |link|
    if Torrent.matches_series(link, terms.last)
      puts link.to_json, ','
    end
  end
  puts ']'
end

main ARGV

