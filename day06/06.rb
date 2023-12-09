#!/usr/bin/env ruby
# frozen_string_literal: true

$stdout.sync = true

f = File.read('input.txt')
lines = f.split("\n")

times = lines[0].split[1..].map(&:to_i)
distances = lines[1].split[1..].map(&:to_i)
races = times.zip(distances).to_h

def solve(races)
  combos = []

  races.each_pair do |t, d|
    first_win = (0..t / 2).bsearch { |b| (t - b) * b > d }
    last_win  = (t / 2..t).bsearch { |b| (t - b) * b < d } - 1
    combos << last_win - first_win + 1
  end

  combos.reduce(:*)
end

puts solve(races)
puts solve({ races.keys.map(&:to_s).join.to_i => races.values.map(&:to_s).join.to_i })
