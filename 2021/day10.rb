#!/usr/bin/env ruby

# for each char in a line
# if opener, push char into array
# if closer, check last val in array
# if matches last val, pop off val
# else invalid

def parse_input
  chunks = []

  File.open('day10_input.txt').each_with_index do |line, idx|
    chunks << line
  end

  chunks
end

def test_chunk(chunk:)
  pairs = {
    '(': ')',
    '{': '}',
    '[': ']',
    '<': '>'
  }

  scores = {
    ')': 3,
    '}': 1197,
    ']': 57,
    '>': 25137
  }

  openers = pairs.keys.map(&:to_s)
  closers = pairs.values.map(&:to_s)

  chunk_arr = chunk.split('')
  chunk_arr.pop
  tested = []

  chunk_arr.each do |char|
    if openers.include?(char)
      tested << char
    elsif tested.last && (pairs[tested.last.to_sym] == char)
      tested.pop
    else
      puts "invalid! score: #{scores[char.to_sym]}"
      return scores[char.to_sym]
    end
  end

  0
end

chunks = parse_input
score = 0

chunks.each do |chunk|
  score += test_chunk(chunk: chunk)
end

puts "total score: #{score}"
