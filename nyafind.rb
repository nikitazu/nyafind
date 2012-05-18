#!/usr/bin/ruby

require './nyalib/torrent.rb'

def main(terms)
  Torrent.load_and_parse(terms) do |link|
    link.print
  end
end

main ARGV

