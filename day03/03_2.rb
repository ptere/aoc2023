#!/usr/bin/env ruby
# frozen_string_literal: true

$stdout.sync = true

f = File.read('input.txt')

# Approach:
# * Find the location of each star
# * Get the 3x3 grid of characters around that
# * Check that grid for any digits
# * If exactly two non-sequential digits are found, add that star to the list of gears
# * For each gear, find a digit for each of the adjacent numbers, and slurp up the number it is a part of
# * Do the result math (multiply pairs, then sum) on those numbers

# Known constraint: numbers are at most 3 digits
# Known constraint: no '*'s appear on the first or last line or column of the input

# thegrid is addressed as thegrid[row][col]

lines = f.split
thegrid = []
stars = []
lines.each_with_index do |line, li|
  thegrid[li] = []
  line.chars.each_with_index do |char, ci|
    thegrid[li][ci] = char
    stars << [ci, li] if char == '*'
  end
end

def slurp(grid, row, col)
  Integer(grid[row][col]) # sanity check - will raise if not a number

  # Go back to the beginning of the number
  col -= 1 while Integer(grid[row][col - 1], exception: false)
  begincol = col

  # Move forward and gobble up the whole number
  col += 1 while Integer(grid[row][col], exception: false)

  Integer(grid[row][begincol...col].join)
end

two_adjacent = []

stars.each do |coordinates|
  adjacent_numbers = 0
  col, row = coordinates

  (-1..1).each do |i|
    row_portion = thegrid[row - i].slice(col - 1..col + 1).join
    adjacent_numbers += row_portion.split(/(\d+)/).select { |g| g =~ /\d+/ }.size
  end

  two_adjacent << coordinates if adjacent_numbers == 2
end

ratios = 0

two_adjacent.each do |coordinates|
  col, row = coordinates
  nums = []

  (-1..1).each do |i|
    # If there's a number in the middle char of the 3-char line, there can be at most one number in the line.
    # Otherwise, there can be up to two.
    if Integer(thegrid[row - i][col], exception: false)
      nums << slurp(thegrid, row - i, col)
    else
      nums << slurp(thegrid, row - i, col - 1) if Integer(thegrid[row - i][col - 1], exception: false)
      nums << slurp(thegrid, row - i, col + 1) if Integer(thegrid[row - i][col + 1], exception: false)
    end
  end

  raise if nums.size != 2 # sanity check

  ratios += nums.reduce(&:*)
end

puts ratios
