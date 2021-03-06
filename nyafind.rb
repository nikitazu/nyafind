#!/usr/bin/env ruby

$:.unshift(File.dirname(__FILE__) + '/nyalib')

require 'json'
require 'torrent.rb'

def main(terms)
  puts '['
  Torrent.load_and_parse(terms) do |link|
    puts link.to_json, ','
  end
  puts ']'
end

main ARGV

