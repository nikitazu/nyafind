#!/usr/bin/env ruby

$:.unshift(File.dirname(__FILE__) + '/nyalib')

require 'json'
require 'anime.rb'

def main(login)
  if login.nil?
    puts "ERROR: login not specified"
    puts "USAGE: nyafind mylogin"
    exit(1)
  end
  
  puts '['
  Anime.load_and_parse(login) do |anime|
    puts anime.to_json, ','
  end
  puts ']'
end

main ARGV.first
