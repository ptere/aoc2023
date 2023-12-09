#!/usr/bin/env ruby
# frozen_string_literal: true

linesums = []

File.open("#{__dir__}/input.txt", 'r') do |f|
  f.each_line do |line|
    li = line.index(/[1-9]/)
    ri = line.rindex(/[1-9]/)
    linesum = line[li] + line[ri]
    linesums << linesum.to_i
  end
end

puts linesums.sum
