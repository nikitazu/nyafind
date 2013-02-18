#!/usr/bin/ruby

$:.unshift(File.dirname(__FILE__) + '/nyalib')

require 'torrent.rb'

def main(terms)
  Torrent.load_and_parse(terms) do |link|
    link.print
  end
end

main ARGV

