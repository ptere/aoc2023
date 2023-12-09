#!/usr/bin/env ruby
# frozen_string_literal: true

f = File.read('input.txt')
lines = f.split("\n")

forward_sum = 0
backward_sum = 0

lines.each do |line|
  values = line.split.map(&:to_i)
  iterations = [values]

  while iterations.last.any? { |i| i != 0 }
    iterations << (0...iterations.last.size - 1).reduce([]) do |acc, i|
      acc << iterations.last[i + 1] - iterations.last[i]
    end
  end

  forward_run = 0
  backward_run = 0

  iterations.reverse.each do |itr|
    forward_run = itr.last + forward_run
    backward_run = itr.first - backward_run
  end

  forward_sum += forward_run
  backward_sum += backward_run
end

puts forward_sum
puts backward_sum
