#!/usr/bin/env ruby
# frozen_string_literal: true

$stdout.sync = true

# Approach:
# * Find each number
# * Pull a subgrid of that number + one character out in each direction
# * Turn that subgrid into a linear string
# * Check the string for anything that isn't a digit or a period

# Simplifying assumption: edges of grid will not have any equipment

f = File.read('input.txt')
lines = f.split

thegrid = []
lines.each_with_index do |line, li|
  thegrid[li] = []
  line.chars.each_with_index do |char, ci|
    thegrid[li][ci] = char
  end
end

linecount = thegrid.size

sum = 0

(0..linecount - 1).each do |middle_scan_line|
  chunks = thegrid[middle_scan_line].join.split(/(\d+)/)
  linepos = 0

  chunks.each do |cnk|
    if Integer(cnk, exception: false)
      chars_to_scan = ''
      ([0, middle_scan_line - 1].max..[middle_scan_line + 1, linecount - 1].min).each do |lineno|
        chars_to_scan += thegrid[lineno].slice([linepos - 1, 0].max..linepos + cnk.size).join
      end

      sum += Integer(cnk) if chars_to_scan =~ /[^(\d|.)]+/
    end

    linepos += cnk.size
  end
end

puts sum
