#!/usr/bin/env ruby
# frozen_string_literal: true

powers = 0

File.open('input.txt', 'r') do |f|
  f.each_line do |line|
    line_parts = line.strip.split(':')
    rounds = line_parts[1].split(';').map(&:strip)
    draws = rounds.map { |r| r.split(',') }

    mins = { 'red' => 0, 'green' => 0, 'blue' => 0 }

    draws.each do |draw|
      draw.each do |balls|
        draw_data = balls.split(' ')
        quantity = draw_data[0].to_i
        color = draw_data[1]

        mins[color] = [mins[color], quantity].max
      end
    end

    powers += mins.values.inject(:*)
  end
end

puts powers
