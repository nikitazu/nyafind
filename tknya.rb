#!/usr/bin/env ruby

require 'tk'
require './nyalib/anime.rb'
require './nyalib/torrent.rb'


root = TkRoot.new { title "Hello, World!" }

TkLabel.new(root) do
  text 'Nyanimate'
  grid :row => 0, :column => 0
end

titles = TkListbox.new(root) do
  width 40
  height 15
  selectmode :single
  grid :row => 1, :column => 0
end

currents = TkListbox.new(root) do
  width 5
  height 15
  selectmode :single
  grid :row => 1, :column => 1 
end

totals = TkListbox.new(root) do
  width 5
  height 15
  selectmode :single
  grid :row => 1, :column => 2
end


torrents = TkListbox.new(root) do
  width 40
  height 15
  selectmode :single
  grid :row => 2, :column => 0
end

seeds = TkListbox.new(root) do
  width 5
  height 15
  selectmode :single
  grid :row => 2, :column => 1
end

leechs = TkListbox.new(root) do
  width 5
  height 15
  selectmode :single
  grid :row => 2, :column => 2
end

Anime.load_and_parse('nikitazu') do |anime|
  titles.insert :end, anime.title
  currents.insert :end, anime.progress.current
  totals.insert :end, anime.progress.max
end

titles.bind('ButtonRelease-1') do
  index = titles.curselection[0]
  title = titles.get(index)
  series = Integer(currents.get(index))
  series2 = series + 1
  query = title.split(' ') << series2
  
  torrents.delete 0, :end
  seeds.delete 0, :end
  leechs.delete 0, :end
  
  Torrent.load_and_parse(query) do |link|
    torrents.insert :end, link.title
    seeds.insert :end, link.seed
    leechs.insert :end, link.leech
  end
end

Tk.mainloop
