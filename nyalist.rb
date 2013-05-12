#!/usr/bin/env ruby

$:.unshift(File.dirname(__FILE__) + '/nyalib')

require 'json'
require 'anime.rb'

def main(args)
  login, status = args
  
  if login.nil?
    puts "ERROR: login not specified"
    puts "USAGE: nyafind mylogin [status]"
    puts "       where status = pending|watching|completed|onhold|dropped"
    exit(1)
  end
  
  puts '['
  Anime.load_and_parse(login, status) do |anime|
    puts anime.to_json, ','
  end
  puts ']'
end

main ARGV

