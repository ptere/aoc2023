#!/usr/bin/env ruby
# frozen_string_literal: true

# Edge case: "4twone" is interpreted as 41, not 42.

EXPANSIONS = { 'o' => %w[one],
               't' => %w[two three],
               'f' => %w[four five],
               's' => %w[six seven],
               'e' => %w[eight],
               'n' => %w[nine] }.freeze

WORD_TO_DIGIT = { 'one' => '1', 'two' => '2', 'three' => '3', 'four' => '4', 'five' => '5',
                  'six' => '6', 'seven' => '7', 'eight' => '8', 'nine' => '9' }.freeze

def find_number(str, positions)
  positions.each do |i|
    c = str[i]
    return c if c =~ /[1-9]/

    number_words = EXPANSIONS[c]
    next if number_words.nil?

    number_words.each do |word|
      return WORD_TO_DIGIT[word] if str[i, word.size] == word
    end
  end
end

linesums = []

File.open('input.txt', 'r') do |f|
  f.each_line do |line|
    leftdigit = find_number(line, (0..line.size - 1).to_a)
    rightdigit = find_number(line, (0..line.size - 1).to_a.reverse)

    linesums << (leftdigit + rightdigit).to_i
  end
end

puts linesums.sum
