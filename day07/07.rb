#!/usr/bin/env ruby
# frozen_string_literal: true

# Provide type for hands with at least one joker
def unfunny_type(hand)
  # Tallies you can be dealt, assuming at least one joker. Tally excludes jokers.

  # nil
  # 1
  # 1 1
  # 1 1 1
  # 1 1 1 1
  # 1 2     -> tempting to go to :house, but :four_kind is better
  # 1 1 2
  # 1 3
  # 2 2     -> best you can do here is :house

  card_tally = hand.chars.tally
  joker_count = card_tally.delete('J')

  raise if joker_count.nil? # sanity check

  # Uncommon cases
  return :house if card_tally.values == [2, 2] # e.g. "2T2TJ" => :house
  return :five_kind if joker_count == 5 # "JJJJJ" => :five

  best_option = card_tally.values.max + joker_count

  types = { 5 => :five_kind, 4 => :four_kind, 3 => :three_kind, 2 => :one_pair }.freeze
  types[best_option]
end

def find_type(hand, joker_mode)
  return unfunny_type(hand) if hand.index('J') && joker_mode

  tally_to_type = { [5] => :five_kind,
                    [1, 4] => :four_kind,
                    [2, 3] => :house,
                    [1, 1, 3] => :three_kind,
                    [1, 2, 2] => :two_pair,
                    [1, 1, 1, 2] => :one_pair,
                    [1, 1, 1, 1, 1] => :high }.freeze

  tally_to_type[hand.chars.tally.values.sort]
end

TYPE_ORDER = %i[five_kind four_kind house three_kind two_pair one_pair high].freeze

def compare_type(type1, type2)
  TYPE_ORDER.index(type2) - TYPE_ORDER.index(type1)
end

CARD_ORDER_REG_MODE   = %w[A K Q J T 9 8 7 6 5 4 3 2].freeze
CARD_ORDER_JOKER_MODE = %w[A K Q T 9 8 7 6 5 4 3 2 J].freeze

def compare_cards(first, second, joker_mode)
  card_order = joker_mode ? CARD_ORDER_JOKER_MODE : CARD_ORDER_REG_MODE

  (0..).each do |i| # Assume no two identical hands in input
    compare_result = card_order.index(second[i]) - card_order.index(first[i])
    return compare_result unless compare_result.zero?
  end
end

def compare_hands(first, second, joker_mode)
  type_result = compare_type(find_type(first, joker_mode), find_type(second, joker_mode))
  type_result.zero? ? compare_cards(first, second, joker_mode) : type_result
end

def score(hands, joker_mode)
  sorted_hands = hands.sort { |a, b| compare_hands(a[0], b[0], joker_mode) }
  sorted_hands.each_with_index.reduce(0) { |acc, (h, i)| acc + Integer(h[1]) * (i + 1) }
end

hands = []
File.open('input.txt', 'r') do |f|
  hands = f.each_line.map(&:split)
end

puts score(hands, false)
puts score(hands, true)
