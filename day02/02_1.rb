#!/usr/bin/env ruby
# frozen_string_literal: true

PLAUSIBLE_MAX = { 'red' => 12, 'green' => 13, 'blue' => 14 }.freeze

game_number_sum = 0

File.open('input.txt', 'r') do |f|
  f.each_line do |line|
    line_parts = line.strip.split(':')
    game_number = line_parts[0].delete_prefix('Game ').to_i
    rounds = line_parts[1].split(';')
    draws = rounds.map { |r| r.split(',') }

    plausible = true

    draws.each do |draw|
      draw.each do |balls|
        draw_data = balls.split(' ')
        quantity = draw_data[0].to_i
        color = draw_data[1]

        plausible = false if quantity > PLAUSIBLE_MAX[color]
      end
    end

    game_number_sum += game_number if plausible
  end
end

puts game_number_sum
