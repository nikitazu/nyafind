#!/usr/bin/env ruby

require 'tk'
require './nyalib/anime.rb'
require './nyalib/torrent.rb'


class NyaWindow
  
  def initialize
    @nyaFont = TkFont.new( :family => 'Helvectica',
                           :size => 20,
                           :weight => :bold )
    
    @mewFont = TkFont.new( :family => 'Monospace',
                           :size => 14 )                  
    
    @root = TkRoot.new { title "Hello, World!" }
    
    TkLabel.new(@root) do
      text 'Nyanimate'
      grid :row => 0, :column => 0
      font @nyaFont
    end
  end

  def table(height, row)
    [ self.listbox(50, 15, row, 0),
      self.listbox(5, 15, row, 1),
      self.listbox(5, 15, row, 2)
    ]
  end

  def listbox(width, height, row, column)
    TkListbox.new(@root) do
      width width
      height height
      selectmode :single
      grid :row => row, :column => column
      font @mewFont
    end
  end

end #class

window = NyaWindow.new

titles, currents, totals = window.table(15, 1)
torrents, seeds, leechs = window.table(15, 2)


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
    torrents.insert :end, link.link
    seeds.insert :end, link.seed
    leechs.insert :end, link.leech
  end
end

Tk.mainloop
