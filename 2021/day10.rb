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

  part1_scores = {
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
      return { part1: part1_scores[char.to_sym], part2: nil }
    end
  end

  { part1: 0, part2: tested }
end

chunks = parse_input
part1_score = 0
incomplete = []

chunks.each do |chunk|
  res = test_chunk(chunk: chunk)
  part1_score += res[:part1]
  incomplete << res[:part2]
end

def autocomplete_score(char)
  pairs = {
    '(': ')',
    '{': '}',
    '[': ']',
    '<': '>'
  }

  autocomplete_scores = {
    ')': 1,
    ']': 2,
    '}': 3,
    '>': 4
  }

  autocomplete_scores[pairs[char.to_sym].to_sym]
end

part2_scores = []

incomplete.compact.each do |inc|
  line_score = 0

  inc.reverse.each do |char|
    line_score *= 5
    line_score += autocomplete_score(char)
  end

  part2_scores << line_score
end

puts "part 1 score: #{part1_score}"

part2_scores = part2_scores.sort
length = part2_scores.length
middle = length * 0.5
middle_idx = middle.ceil - 1

puts "part 2 scores length: #{length}"
puts "part 2 scores: #{part2_scores}"
puts "part 2 scores middle idx: #{middle_idx}"
puts "middle score: #{part2_scores[middle_idx]}"

