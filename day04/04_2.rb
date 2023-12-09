#!/usr/bin/env ruby
# frozen_string_literal: true

$stdout.sync = true

f = File.read('input.txt')
lines = f.split("\n")

card_copies = [1] * lines.size

lines.each_with_index do |l, lnum|
  *, cards = l.split(':')

  winning_cards, your_cards = cards.split('|').map(&:strip).map(&:split)
  common_cards = winning_cards.intersection(your_cards)

  next unless common_cards

  (1..common_cards.size).each do |c|
    card_copies[lnum + c] += card_copies[lnum]
  end
end

puts card_copies.sum
