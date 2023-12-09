#!/usr/bin/env ruby
# frozen_string_literal: true

$stdout.sync = true

f = File.read('input.txt')

parts = f.split(/^$/)
seeds = parts[0].strip.split(':')[1].strip.split.map { |n| Integer(n) }

def lookup(table, item_no)
  table.each do |row|
    return (item_no - row[1] + row[0]) if row[1] < item_no && row[1] + row[2] > item_no
  end
  item_no
end

results = []
seeds.each do |seed|
  (1..parts.size - 1).each do |i|
    lines = parts[i].strip.split("\n")
    rest = lines[1..]

    ranges = rest.map { |r| r.split.map { |n| Integer(n) } }
    seed = lookup(ranges, seed)
  end
  results << seed
end

puts results.min
