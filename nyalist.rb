#!/usr/bin/env ruby

$:.unshift(File.dirname(__FILE__) + '/nyalib')

require 'json'
require 'anime.rb'

STATUSES = {
  'pending' => 6,
  'watching' => 1,
  'completed' => 2,
  'onhold' => 3,
  'dropped' => 4
}

def main(args)
  login, status = args
  
  if login.nil?
    puts "ERROR: login not specified"
    puts "USAGE: nyafind mylogin [status]"
    puts "       where status = pending|watching|completed|onhold|dropped"
    exit(1)
  end
  
  status_id = STATUSES[status]
  if status.nil?
    status_id = STATUSES['watching']
  end
  
  puts '['
  Anime.load_and_parse(login, status_id) do |anime|
    puts anime.to_json, ','
  end
  puts ']'
end

main ARGV

