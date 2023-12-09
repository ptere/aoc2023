#!/usr/bin/env ruby
# frozen_string_literal: true

$stdout.sync = true

f = File.read('input.txt')

# General approach:
# Since the mappings between each level all increase uniformly
# (if n maps to m, then n+1 will either map to m+1, or some completely other value, but not m-1 or m+2),
# we can simplify by only checking the opening boundary of each mapping.
#
# 1. Starting at each opening boundary for each mapping, follow the mapping to the end location
# 2. If the end location is lower than we've ever seen it before, check if it's possible
#    to reach a seed range (climb back up the mappings)
# 3. If so, store that end location as the best yet (closest found so far)
# 4. Once all mapping boundaries have been explored, report the closest location found

# Not implemented: This only checks boundaries from within the mappings.
# If the optimal answer comes from the boundary of a seed range, it will be missed.

parts = f.split(/^$/)
input_ranges = parts[0].strip.split(':')[1].strip.split.map { |n| Integer(n) }

seed_ranges = []
(0..(input_ranges.size / 2) - 1).each do |i|
  seed_ranges << (input_ranges[i * 2]..input_ranges[i * 2] + input_ranges[i * 2 + 1])
end

mappings = []
(1..parts.size - 1).each do |i|
  lines = parts[i].strip.split("\n")
  mappings << lines[1..].map { |r| r.split.map { |n| Integer(n) } }
end

def convert_to_next_map(mapping, item_number)
  mapping.each do |entry|
    return (item_number - entry[1] + entry[0]) if entry[1] <= item_number && entry[1] + entry[2] > item_number
  end
  item_number # fall through
end

def convert_to_prev_map(mapping, item_number)
  mapping.each do |entry|
    return (item_number - entry[0] + entry[1]) if entry[0] <= item_number && entry[0] + entry[2] > item_number
  end
  item_number
end

closest = nil

mappings.each_with_index do |mapping, mapping_number|
  mapping.each do |entry|
    downward_item_number = entry[1]

    mappings[mapping_number..].each do |trace_down_mapping|
      downward_item_number = convert_to_next_map(trace_down_mapping, downward_item_number)
    end

    next unless closest.nil? || downward_item_number < closest

    # Found a potential answer. Check if it's reachable from the seed ranges.
    upward_item_number = entry[1]

    mappings[0...mapping_number].reverse.each do |trace_up_mapping|
      upward_item_number = convert_to_prev_map(trace_up_mapping, upward_item_number)
    end

    closest = downward_item_number if seed_ranges.any? { |sr| sr.include? upward_item_number }
  end
end

puts closest
