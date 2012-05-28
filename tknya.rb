#!/usr/bin/env ruby

require 'tk'

root = TkRoot.new { title "Hello, World!" }

TkLabel.new(root) do
  text 'Nyanimate'
  grid :row => 0, :column => 0
end

titles = TkListbox.new(root) do
  width 30
  height 10
  grid :row => 1, :column => 0
end

currents = TkListbox.new(root) do
  width 5
  height 10
  grid :row => 1, :column => 1 
end

totals = TkListbox.new(root) do
  width 5
  height 10
  grid :row => 1, :column => 2
end

torrents = TkListbox.new(root) do
  width 30
  height 5
  grid :row => 2, :column => 0
end

seeds = TkListbox.new(root) do
  width 5
  height 5
  grid :row => 2, :column => 1
end

leechs = TkListbox.new(root) do
  width 5
  height 5
  grid :row => 2, :column => 2
end

titles.insert 0, 'Tsukihime', 'Fate/Stay night'
currents.insert 0, 10, 20
totals.insert 0, 26, 26

torrents.insert 0, '[Zero-Rws] Tsukihime - 11', '[Horrible] Tsukihime 11'
seeds.insert 0, 100, 320
leechs.insert 0, 230, 558

Tk.mainloop
