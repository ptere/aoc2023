#!/usr/bin/env ruby
# frozen_string_literal: true

f = File.read('input.txt')
lines = f.split("\n")

INSTRUCTIONS = lines[0].strip.chars
NETWORK = lines[2..].reduce({}) do |acc, entry|
  acc.merge({ entry[0...3] => { 'L' => entry[7...10], 'R' => entry[12...15] } })
end

def part1
  position = 'AAA'
  instructions_offset = steps = 0

  while position != 'ZZZ' && steps < 50_000 # guard against infinite loop
    next_positions = NETWORK[position]
    position = next_positions[INSTRUCTIONS[instructions_offset]]
    steps += 1

    # Move to next instruction, or wrap around to the beginning
    instructions_offset = instructions_offset < INSTRUCTIONS.size - 1 ? instructions_offset + 1 : 0
  end

  steps
end

def steps_to_z(start_position)
  position = start_position
  steps = instructions_offset = 0
  zs_at = []

  while steps.zero? || steps < 100_000
    position = NETWORK[position][INSTRUCTIONS[instructions_offset]]
    instructions_offset = instructions_offset < INSTRUCTIONS.size - 1 ? instructions_offset + 1 : 0
    steps += 1

    zs_at << steps if position[2] == 'Z'
  end

  zs_at
end

def part2
  positions = NETWORK.keys.select { |k| k[2] == 'A' }

  cycle_list = []
  positions.each do |start_position|
    cycle_list << steps_to_z(start_position)
  end

  # Luckily all cycles are simple regular intervals
  cycle_list.map(&:first).reduce(&:lcm)
end

puts part1
puts part2
