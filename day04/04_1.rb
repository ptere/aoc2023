#!/usr/bin/env ruby
# frozen_string_literal: true

$stdout.sync = true

f = File.read('input.txt')
lines = f.split("\n")

sum = 0

lines.each do |l|
  *, cards = l.split(':')

  winning_cards, your_cards = cards.split('|').map(&:strip).map(&:split)
  common_cards = winning_cards.intersection(your_cards)

  sum += common_cards.empty? ? 0 : 2**(common_cards.size - 1)
end

puts sum
